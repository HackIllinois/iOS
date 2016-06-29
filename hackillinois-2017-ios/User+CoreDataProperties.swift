//
//  User+CoreDataProperties.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 6/29/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension User {

    @NSManaged var barcode: String
    @NSManaged var barcodeData: NSData
    @NSManaged var major: String
    @NSManaged var initTime: NSDate
    @NSManaged var name: String
    @NSManaged var role: String
    @NSManaged var school: String
    @NSManaged var token: String
    @NSManaged var expireTime: NSDate
    @NSManaged var email: String
    @NSManaged var userID: NSNumber

}
