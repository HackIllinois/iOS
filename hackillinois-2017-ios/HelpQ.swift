//
//  HelpQ.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 6/21/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

import Foundation
import CoreData


class HelpQ: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    func initialize(technology: String, language: String, location: String, description: String) {
        self.resolved = NSNumber(bool: false)
        self.technology = technology
        self.language = language
        self.location = location
        self.desc = description
        self.initiation = NSDate()
        self.modified = NSDate()
        self.chats = NSOrderedSet()
        self.isHelping = NSNumber(bool: false)
        self.mentor = ""
    }
    
    func initialize(resolved: Bool, technology: String, language: String, location: String, description: String, chats: [Chat]) {
        self.resolved = NSNumber(bool: resolved)
        self.technology = technology
        self.language = language
        self.location = location
        self.desc = description
        self.initiation = NSDate()
        self.modified = NSDate()
        self.chats = NSOrderedSet(array: chats)
        self.isHelping = NSNumber(bool: false)
        self.mentor = ""
    }
    
    func initialize() {
        self.resolved = NSNumber(bool: false)
        self.technology = "Node JS"
        self.language = "Javascript"
        self.location = "1404 Siebel"
        self.desc = "Help with asynchronous calls"
        self.initiation = NSDate()
        self.modified = NSDate()
        self.chats = NSOrderedSet()
        self.isHelping = NSNumber(bool: false)
        self.mentor = ""
    }
    
    func assignMentor(mentor mentor: String, helpStatus: Bool) {
        self.isHelping = NSNumber(bool: helpStatus)
        self.mentor = mentor
    }
    
    func updateModifiedTime() {
        self.modified = NSDate()
        Helpers.saveContext()
    }
    
    func pushChatItem(chat chat: Chat) {
        chat.helpQ = self // Set this object as the head
        
        let mutableVersion = self.chats.mutableCopy() as! NSMutableOrderedSet
        mutableVersion.addObject(chat)
        self.chats = mutableVersion
        Helpers.saveContext() // Save after changing item
    }

}
