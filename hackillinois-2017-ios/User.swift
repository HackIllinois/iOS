//
//  User.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 5/23/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

import Foundation
import CoreData


class User: NSManagedObject {

    /* Convenience updating function */
    func initialize(name name: String, email: String, school: String, major: String, role: String, barcode: String, barcodeData: NSData, token: String, initTime: NSDate, expirationTime: NSDate, userID: NSNumber) {
        self.barcode = barcode
        self.barcodeData = barcodeData
        self.major = major
        self.initTime = initTime
        self.name = name
        self.role = role
        self.school = school
        self.token = token
        self.expireTime = expirationTime
        self.email = email
        self.userID = userID
    }

}
