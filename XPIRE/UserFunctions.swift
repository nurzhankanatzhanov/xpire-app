//
//  UserFunctions.swift
//  XPIRE
//
//  Created by Mando Quintana on 3/14/21.
//
import UIKit
import Foundation
import CoreData
import WidgetKit

enum UserExceptions : Error {
  case noUserFound
}

public func loadUser() throws -> User {
    var context: NSManagedObjectContext!{
        return (UIApplication.shared.delegate as? AppDelegate)?
        .persistentContainer.viewContext
    }
    
    let userDataRequest: NSFetchRequest<User> = User.fetchRequest()
    userDataRequest.fetchLimit = 1
    
    var users = [NSManagedObject]()
    do {
        users = try context.fetch(userDataRequest)
    } catch let error as NSError {
        print("Could not fetch from Core Data. \(error), \(error.userInfo)")
    }
    
    if users.isEmpty {
        throw UserExceptions.noUserFound
    }
    let userToLoad = users.first
    return userToLoad as! User
}

public func getUserInventory() -> [SavedProduct] {
    do {
        user = try loadUser()
    }
    catch {
        print(error.localizedDescription)
    }
    guard let userInventory = user.saved_products else { return [] }
    inventory = userInventory
    return inventory
}

public func updateInventory(inventory: [SavedProduct]) {
    var context: NSManagedObjectContext!{
        return (UIApplication.shared.delegate as? AppDelegate)?
        .persistentContainer.viewContext
    }
    
    do {
        user = try loadUser()
        
        user.saved_products = inventory
        try context.save()
    }
    catch {
        print(error.localizedDescription)
    }
}

public func deleteProduct(index: Int){
    var context: NSManagedObjectContext!{
        return (UIApplication.shared.delegate as? AppDelegate)?
        .persistentContainer.viewContext
    }
    do {
        user = try loadUser()
        user.saved_products?.remove(at: index)
        try context.save()
        
        _ = getExpiringFoods()
    } catch {
        fatalError("Failure to save context: \(error)")
    }
}

public func saveProduct(productToSave: SavedProduct) {
    var context: NSManagedObjectContext!{
        return (UIApplication.shared.delegate as? AppDelegate)?
        .persistentContainer.viewContext
    }
    do {
        user = try loadUser()
        user.saved_products?.append(productToSave)
        try context.save()
    } catch {
        fatalError("Failure to save context: \(error)")
    }
}

// returns only the expiring foods within a certain timeframe set by the user (from today to expiration date)
public func getExpiringFoods() -> [SavedProduct] {
    let allInventory = getUserInventory()
    let reminderFrequency = getReminderFrequency()
    
    // filter dates that are within a time frame
    var expiringInventory = allInventory.filter {
        isWithinTimeFrame(expirationDate: $0.expirationDate, today: Date(), timeFrame: reminderFrequency)
    }
    
    // sort in increasing calendar order (oldest dates first - closest to expiration)
    expiringInventory.sort {
        $0.expirationDate < $1.expirationDate
    }

    // user default creation for the Widget, reloads the timelines to display up-to-date information
    if expiringInventory.count != 0 {
        let maxCount = expiringInventory.count > 6 ? 6 : expiringInventory.count
        createUserDefaults(productArray: Array(expiringInventory.prefix(maxCount)) )
    } else {
        // if there's no expiring foods to display, just set the message
        UserDefaults(suiteName: "group.XPIRE-widget")!.set(["No expiring foods to display!"], forKey: "names")
        UserDefaults(suiteName: "group.XPIRE-widget")!.set([], forKey: "dates")
    }
    // reload the timelines for the widget kit
    WidgetCenter.shared.reloadAllTimelines()
    
    return expiringInventory
}

public func createUserDefaults(productArray: [SavedProduct]) {
    var nameArray: [String] = []
    var expirationArray: [String] = []
    for product in productArray {
        let (name, _) = splitProductNameAndDescription(fullName: product.name)
        //nameArray.append("\(name) (\(product.stringifyExpirationDate(shortenDate: true)))")
        nameArray.append("\(name) (\(getDaysBeforeExpiration(product: product)))")
        expirationArray.append(product.stringifyExpirationDate(shortenDate: true))
    }
    UserDefaults(suiteName: "group.XPIRE-widget")!.set(nameArray, forKey: "names")
    UserDefaults(suiteName: "group.XPIRE-widget")!.set(expirationArray, forKey: "dates")
}

// pulling the Core Data reminder_freq attribute of a User
public func getReminderFrequency() -> Int {
    do {
        user = try loadUser()
    }
    catch {
        print(error.localizedDescription)
    }
    
    let reminderFrequency = user.reminder_freq
    return Int(reminderFrequency)
}

// need to see if the passed in expiration date is within a certain time (reminder_freq) of today
public func isWithinTimeFrame(expirationDate: Date, today: Date, timeFrame: Int) -> Bool {
    let numberOfDaysBetween = Calendar.current.dateComponents([.day], from: today, to: expirationDate).day ?? 0
    return numberOfDaysBetween < timeFrame
}

// total point update to Core Data
public func updateTotalPoints(pointAmount: Int) {
    var context: NSManagedObjectContext!{
        return (UIApplication.shared.delegate as? AppDelegate)?
        .persistentContainer.viewContext
    }
    do {
        user = try loadUser()
        user.total_points += Int32(pointAmount)
        try context.save()
    } catch {
        fatalError("Failure to save context: \(error)")
    }
}

// getting total points from Core Data
public func getPoints() -> Int {
    do {
        user = try loadUser()
    }
    catch {
        print(error.localizedDescription)
    }
    
    let totalPoints = user.total_points
    return Int(totalPoints)
}

// get the default storage method set by the user
public func getStorageMethod() -> String {
    do {
        user = try loadUser()
    }
    catch {
        print(error.localizedDescription)
    }
    
    guard let defaultMethod = user.default_storage_method else { return "Pantry" }
    return defaultMethod
}

// splitting the API returned full product string into actual product name and its description
public func splitProductNameAndDescription(fullName: String) -> (String, String) {
    // separate strings based on these characters: , - – — ( )
    let regexString = fullName.replacingOccurrences(of: "[\\,\\-\\–\\—\\(\\)]", with: "\0", options: .regularExpression)
    // only split on the first occurrence
    let result = regexString.split(separator: "\0", maxSplits: 1)
    
    let productName = result[0]
    let trimmedName = productName.trimmingCharacters(in: .whitespacesAndNewlines)
    // now combine all other occurrences after the first
    let conditions = result[1].components(separatedBy: "\0")
    
    // remove all whitespaces and any empty strings
    var trimmed = conditions.map { $0.trimmingCharacters(in: .whitespaces) }
    trimmed = trimmed.filter { !$0.isEmpty }
    
    // join all conditions on the | separator
    let description = trimmed.joined(separator: " | ")
    
    return (trimmedName, description)
}

// calculate the days between today and expiration date
public func getDaysBeforeExpiration(product: SavedProduct) -> String {
    let daysBetween = Calendar.current.dateComponents([.day], from: Date(), to: product.expirationDate).day!
    
    switch daysBetween {
        case 1: return "\(daysBetween) day left"
        case 1...10: return "\(daysBetween) days left"
        case 0: return "expires today"
        case -1: return "expired \(daysBetween * -1) day ago"
        default: return "expired \(daysBetween * -1) days ago"
    }
}

