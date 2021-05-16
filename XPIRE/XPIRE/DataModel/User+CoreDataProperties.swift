//
//  User+CoreDataProperties.swift
//  XPIRE
//
//  Created by Maclee Machado on 3/4/21.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var default_storage_method: String?
    @NSManaged public var reminder_freq: Int32
    @NSManaged public var saved_products: [SavedProduct]?
    @NSManaged public var total_points: Int32
    @NSManaged public var notifications: [String:[String]]?
   

}

extension User : Identifiable {

}
