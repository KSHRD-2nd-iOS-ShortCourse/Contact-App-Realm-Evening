
//  Person.swift
//  RealmDemo
//
//  Created by Kokpheng on 10/26/16.
//  Copyright © 2016 Kokpheng. All rights reserved.
//

import Foundation
import RealmSwift

class Person: Object {
    dynamic var name = ""
    dynamic var age = 0
    dynamic var profile = NSData()
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
    

}
