//
//  HelpQ.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 6/14/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

import Foundation

/* Describes one item of HelpQ request */

class HelpQ {
    init(technology: String, language: String, location: String, description: String) {
        self.resolved = false
        self.technology = technology
        self.language = language
        self.location = location
        self.desc = description
        self.initiation = NSDate()
        self.modified = NSDate()
    }
    
    init(resolved: Bool, technology: String, language: String, location: String, description: String) {
        self.resolved = resolved
        self.technology = technology
        self.language = language
        self.location = location
        self.desc = description
        self.initiation = NSDate()
        self.modified = NSDate()
    }
    
    init() {
        self.resolved = false
        self.technology = "Node JS"
        self.language = "Javascript"
        self.location = "1404 Siebel"
        self.desc = "Help with asynchronous calls"
        self.initiation = NSDate()
        self.modified = NSDate()
    }
    
    func updateModifiedTime() {
        self.modified = NSDate()
    }
}