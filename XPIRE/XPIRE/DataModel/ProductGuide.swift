//
//  ProductGuide.swift
//  XPIRE
//
//  Created by Mando Quintana on 2/17/21.
//

import Foundation
import UIKit
struct ProductGuide: Decodable {
    let name: String
    let methods: [StorageMethods]
    let tips: [String]
}

struct StorageMethods: Decodable {
    let location: String
    let expiration: String
    let expirationTime: Int
}
