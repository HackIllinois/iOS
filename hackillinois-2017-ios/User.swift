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
    func initialize(barcode: String, name: String, status: String) {
        self.barcode = barcode
        self.name = name
        self.status = status
    }

}
