//
//  SkillLevel.swift
//  XPIRE
//
//  Created by Nurzhan Kanatzhanov on 3/8/21.
//

import UIKit
import Foundation
import CoreData

enum ReadDataExceptions : Error {
  case moreThanOnePersonCameBack
}

// gets the total points value from the attribute in Core Data
// https://www.oreilly.com/library/view/ios-10-swift/9781491966426/ch04.html
public func getTotalPoints() throws -> Int {
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
    
    guard let user = users.first,
      users.count == userDataRequest.fetchLimit else {
        throw ReadDataExceptions.moreThanOnePersonCameBack
    }
    
    let points = user.value(forKeyPath: "total_points") as! Int
    
    return points
}

// get skill level name and number from the appropriate tally of total points (in Core Data)
public func getSkillLevel(totalPoints: Int) -> (name: String, number: Int, description: String, badge: String) {
    //Novice, Newbie, Beginner, Rookie, Intermediate, Proficient, Seasoned, Advanced, Senior, Expert, Champion, Master.
    
    let points = totalPoints
    
    var skillLevelName = ""
    let skillLevelNumber = totalPoints / 100
    var description = ""
    var badge = ""
    
    switch points {
        case 0...99:
            skillLevelName = "Novice"
            description = "Great start! Remember, Rome wasn't built in a day!"
            badge = "🔰"
        case 100...199:
            skillLevelName = "Newbie"
            description = "You are going in the right direction! Keep it up!"
            badge = "👶"
        case 200...299:
            skillLevelName = "Beginner"
            description = "Let's prevent food waste together!"
            badge = "🎒"
        case 300...399:
            skillLevelName = "Rookie"
            description = "Michael Jordan was a rookie once too..."
            badge = "🏀"
        case 400...499:
            skillLevelName = "Intermediate"
            description = "Thanks for all your effort so far, let's keep going!"
            badge = "🤠"
        case 500...599:
            skillLevelName = "Proficient"
            description = "You definitely know what you're doing."
            badge = "🤔"
        case 600...699:
            skillLevelName = "Seasoned"
            description = "Cutting food waste is a delicious way of saving $$$."
            badge = "🧐"
        case 700...799:
            skillLevelName = "Advanced"
            description = "We love food, and it seems like you do too! Keep it up!"
            badge = "🥸"
        case 800...899:
            skillLevelName = "Senior"
            description = "Relationship status: preventing food waste together."
            badge = "🏅"
        case 900...999:
            skillLevelName = "Expert"
            description = "Your expertise in saving food is out of this world, thank you!"
            badge = "🎖"
        case 1000...1099:
            skillLevelName = "Champion"
            description = "You are on top of the world. Alexa, play 'We Are The Champions' by Queen."
            badge = "👑"
        case 1100...1199:
            skillLevelName = "Master"
            description = "A Jack of all trades is a master of...saving food?"
            badge = "🏆"
        case 1200...1299:
            skillLevelName = "Grandmaster"
            description = "Grand Canyon, Grand Slam, Grand Prix...you've done it all!"
            badge = "🎓"
        case 1300...1399:
            skillLevelName = "Veteran"
            description = "Certified Veteran in Food Waste Prevention...sounds good, doesn't it?"
            badge = "🪖"
        default:
            skillLevelName = "Legend-Ninja"
            description = "Thank you for being a part of the XPIRE team for this long. We love you! You can now truly call yourself a 'Legend' in saving food."
            badge = "🥷"
    }
    
    description += " You have \(points) points."
    
    return (skillLevelName, skillLevelNumber, description, badge)
}
