//
//  HelpQ.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 6/14/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

import Foundation
import CoreData

/* Describes one item of HelpQ request */

class HelpQ: NSManagedObject {
    func initialize(technology: String, language: String, location: String, description: String) {
        self.resolved = false
        self.technology = technology
        self.language = language
        self.location = location
        self.desc = description
        self.initiation = NSDate()
        self.modified = NSDate()
        self.chats = NSOrderedSet()
    }
    
    func initialize(resolved: Bool, technology: String, language: String, location: String, description: String, chats: [Chat]) {
        self.resolved = resolved
        self.technology = technology
        self.language = language
        self.location = location
        self.desc = description
        self.initiation = NSDate()
        self.modified = NSDate()
        self.chats = NSOrderedSet(array: chats)
    }
    
    func initialize() {
        self.resolved = false
        self.technology = "Node JS"
        self.language = "Javascript"
        self.location = "1404 Siebel"
        self.desc = "Help with asynchronous calls"
        self.initiation = NSDate()
        self.modified = NSDate()
        self.chats = NSOrderedSet()
    }
    
    func updateModifiedTime() {
        self.modified = NSDate()
    }
    
    func pushChatItem(chat chat: Chat) {
        chat.helpQ = self // Set this object as the head
        
        let mutableVersion = self.chats.mutableCopy() as! NSMutableOrderedSet
        mutableVersion.addObject(chat)
        self.chats = mutableVersion
        Helpers.saveContext() // Save after changing item
    }
}