//
//  SavedProduct.swift
//  XPIRE
//
//  Created by Mando Quintana on 2/27/21.
//

import Foundation
var inventory = [SavedProduct]()
var user: User!
public class SavedProduct : NSObject, NSSecureCoding, Encodable {
    public static var supportsSecureCoding = true
    
    enum Key: String {
        case name = "name"
        case tips = "tips"
        case storage = "storage"
        case purchasedDate = "purchasedDate"
        case expirationDate = "expirationDate"
        case id = "item_id"
    }
    
    let name: String
    let tips: [String]
    let storage: String
    let purchasedDate: Date
    let expirationDate: Date
    let item_id: String
    
    public func encode(with coder: NSCoder) {
        coder.encode(name, forKey: Key.name.rawValue)
        coder.encode(tips, forKey: Key.tips.rawValue)
        coder.encode(storage, forKey: Key.storage.rawValue)
        coder.encode(purchasedDate, forKey: Key.purchasedDate.rawValue)
        coder.encode(expirationDate, forKey: Key.expirationDate.rawValue)
        coder.encode(item_id, forKey: Key.id.rawValue)
    }
    
    public required init?(coder: NSCoder) {
        let mTips = coder.decodeObject(forKey: Key.tips.rawValue) as! [String]
        let mName = coder.decodeObject(forKey: Key.name.rawValue) as! String
        let mstorage = coder.decodeObject(forKey: Key.storage.rawValue) as! String
        let mPurchasedDate = coder.decodeObject(forKey: Key.purchasedDate.rawValue) as! Date
        let mExpirationDate = coder.decodeObject(forKey: Key.expirationDate.rawValue) as! Date
        let mitemd_id = coder.decodeObject(forKey: Key.id.rawValue) as! String
        
        self.name = mName
        self.tips = mTips
        self.storage = mstorage
        self.purchasedDate = mPurchasedDate
        self.expirationDate = mExpirationDate
        self.item_id = mitemd_id;
    }
    
    init(name: String, tips: [String], storage: String, purchasedDate: Date, expirationDate: Date,item_id:String) {
        self.name = name
        self.tips = tips
        self.storage = storage
        self.purchasedDate = purchasedDate
        self.expirationDate = expirationDate
        self.item_id = item_id
      }
    
    public func splitProductNameAndDetails() -> [String] {
        let separators = CharacterSet(charactersIn: ",-–—(")
        return name.components(separatedBy: separators)
    }
    
    //converts any products purchased date using our stringifyDate function
    public func stringifyPurchasedDate(shortenDate: Bool) -> String {
       return stringifyDate(dateToConvert: purchasedDate, wantShorterDate: shortenDate)
    }
    
    //converts any products expiration date using our stringifyDate function
    public func stringifyExpirationDate(shortenDate: Bool) -> String {
        return stringifyDate(dateToConvert: expirationDate, wantShorterDate: shortenDate)
    }
    
    //Converts any given date to format MMM dd or MMM dd, yyyy based on boolean value passed
    private func stringifyDate(dateToConvert: Date, wantShorterDate: Bool) -> String {
        let dateFormatter = DateFormatter()
        
        if wantShorterDate == true {
            dateFormatter.dateFormat = "MMM dd"
        }else{
            dateFormatter.dateFormat = "MMM dd, yyyy"
        }
        return dateFormatter.string(from: dateToConvert)
    }
}

