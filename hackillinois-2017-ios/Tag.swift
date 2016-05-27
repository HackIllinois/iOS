//
//  Tag.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 5/27/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

import Foundation
import CoreData


class Tag: NSManagedObject {
    
    /* Convenience update function */
    func initialize(name: String, feeds: NSSet) {
        self.feeds = feeds
        self.name = name
    }
    
    /* Overrides needs nonobjc methods to compile */
    @nonobjc func initialize(name: String, feeds: [Feed]) {
        self.name = name
        self.feeds = NSSet(array: feeds)
    }
}
