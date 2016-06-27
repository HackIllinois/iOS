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
    func initialize(name name: String, school: String, major: String, role: String, barcode: String, barcodeData: NSData, token: String, modifiedTime: NSDate) {
        self.name = name
        self.school = school
        self.major = major
        self.role = role
        self.barcode = barcode
        self.barcodeData = barcodeData
        self.token = token
        self.modifiedTime = modifiedTime
    }

}
