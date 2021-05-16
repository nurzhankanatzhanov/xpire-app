//
//  Notifications.swift
//  XPIRE
//
//  Created by Anderson Gonzalez on 3/28/21.
//

import Foundation
import UIKit
import CoreData
import UserNotifications



/* Request Persmission from user to send LocalNotification: if the user grants request
   we create a local notification. If user dines request nothing happens. The request happens only once after
   app has lunched.
 item: The SavedProduct item to save
 */
public func requestNotificationPersmission(item: SavedProduct) {
        //get reference to notification center
        let center = UNUserNotificationCenter.current()
        
        //request persmission to send notifications
        center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success{
                // need to delegate in main thread
                DispatchQueue.main.sync {
                    //schedule test notification
                    let freq = getReminderFrequency()
                    setNotification(date: item.expirationDate, freqency: freq , idToAdd: item.item_id, name:item.name)
                }
            }
            else{
                //user dinied us permission print this for now
                print("Please go to notifications setting to grant permission in the future")
                
            }
        }
    }


/*Creates the body of the Notification and send it to NotificationCenter
 date: the Experiration Date of the item notification are being created for
 frequency: the current user frequency (determines the number of notifcations to create)
 idToAdd: The SavedProduct.item_id to save all notifications under in Core Data
 name: SavedProduct.name the name of the item that notifications are being created for.
 */
public func setNotification(date: Date, freqency: Int , idToAdd: String,name: String) {
    //create content for notification
    let content = UNMutableNotificationContent()
    //title of notification
    content.title = name
    
    //set sound for notification to defualt alert sound
    content.sound = .default
    
    //For the frequency, create a notification and add to string list
    var notifList = [String]()
    
    //for debugging date
    let formatter1 = DateFormatter()
    formatter1.dateStyle = .short
    
    //date to use for notification (modefied in loop)
    var realDate = date
    for i in 0...freqency-1 {
        
        var dateComponents =  Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: realDate)
        
        //defines body of notification
        if i == 0 {
            content.body = "This food expires today!"
        }
        else {
            content.body = "Expires in " + String(i) + " days."
        }
        
        //create a unique notification id
        let notifID = UUID().uuidString
        
        //add this to the notifications list for this item
        notifList.append(notifID)
 
        //set notification time to 8:30am
        dateComponents.hour = 8
        dateComponents.minute = 30
        
        let trigger = UNCalendarNotificationTrigger(dateMatching:dateComponents, repeats: false)
        
        //create a request (contains contents and trigger)
        //identifier: will be the strings_id for items added (look at CoreData)
        let request = UNNotificationRequest(identifier: notifID, content: content, trigger: trigger)
                    
        //actually register request with notification center
        UNUserNotificationCenter.current().add(request) { error in
            if error != nil {
                print("Something went wrong check what went wrong")
            }
        }
        
        realDate = realDate.dayBefore;
    }
    
    //store the notifications added to CoreData
    saveNotifications(idToAdd: idToAdd, notifToSave: notifList)
}



/* Prints the contents in a dictionary of key= String , value = [Strings]
 notifData: Dictionary that will be printed
 */
public func printNotifications(notifData :[String:[String]]) {
    for (key, value) in notifData {
        print("\(key) : \(value)")
    }
}


/* Takes the item_id and its notifications list and stores them in CoreData
 idToAdd: SavedProduct.item_id used as the Key for CoreData
 notiftToSave: A String array of unique notifications idenfiers used as the value
               for the key above
 */
public func saveNotifications(idToAdd: String, notifToSave: Array<String>) {
    var context: NSManagedObjectContext!{
        return (UIApplication.shared.delegate as? AppDelegate)?
        .persistentContainer.viewContext
    }
    do {
        user = try loadUser()
        //user.saved_products?.append(productToSave)
        //user.notifications![item!.name] = notifToSave
        user.notifications![idToAdd] = notifToSave
        try context.save()
    } catch {
        fatalError("Failure to save context: \(error)")
    }
}

/*
 Refreshes the apps notifications if the user requested
 more notifications be sent to them. Deletes old notification
 in NotificationCenter and Core Data and add new ones for each
 item in the users inventory
 */
public func frequencyChangedNotifications(){
    let inventory = getUserInventory()
    let center = UNUserNotificationCenter.current()
    center.removeAllPendingNotificationRequests()
    center.removeAllDeliveredNotifications()
    for product in inventory{
        requestNotificationPersmission(item: product)
    }
}

/*
 Gets the stored notifications dictionary from CoreData and prints
 out its contents
 */
public func printNotificationDict(){
    var notifDict = [String:[String]]()
    do {
        user = try loadUser()
        notifDict = user.notifications!
    }
    catch {
        print(error.localizedDescription)
    }
    for (key, value) in notifDict {
        print("\(key) : \(value)")
    }
    
}

/*Deletes the notifications for any item that is deleted from the inventory.
 itemToDelete: SavedProduc.item_id used to identify the items notifications list
 in core data. 
 */

public func deleteAllNotifications(itemToDelete: String) {
    var context: NSManagedObjectContext!{
        return (UIApplication.shared.delegate as? AppDelegate)?
        .persistentContainer.viewContext
    }
    do {
        user = try loadUser()
        //Remove notifications from notification center
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: user.notifications![itemToDelete]!)
        center.removeAllDeliveredNotifications()
        
        //Remove key and value of notification from core data
        if let value = user.notifications!.removeValue(forKey: itemToDelete) {
            print("The value \(value) was removed.")
        }
        try context.save()
    } catch {
        fatalError("Failure to save context: \(error)")
    }
}


extension Date {
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)!
    }

    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)!
    }
}
