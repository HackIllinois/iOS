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
        self.resolved = NSNumber(value: false)
        self.technology = technology
        self.language = language
        self.location = location
        self.desc = description
        self.initiation = Date()
        self.modified = Date()
        self.chats = NSOrderedSet()
        self.isHelping = NSNumber(value: false)
        self.mentor = ""
    }
    
    func initialize(resolved: Bool, technology: String, language: String, location: String, description: String, chats: [Chat]) {
        self.resolved = NSNumber(value: resolved)
        self.technology = technology
        self.language = language
        self.location = location
        self.desc = description
        self.initiation = Date()
        self.modified = Date()
        self.chats = NSOrderedSet(array: chats)
        self.isHelping = NSNumber(value: false)
        self.mentor = ""
    }
    
    func initialize() {
        self.resolved = NSNumber(value: false)
        self.technology = "Node JS"
        self.language = "Javascript"
        self.location = "1404 Siebel"
        self.desc = "Help with asynchronous calls"
        self.initiation = Date()
        self.modified = Date()
        self.chats = NSOrderedSet()
        self.isHelping = NSNumber(value: false)
        self.mentor = ""
    }
    
    func assignMentor(mentor: String, helpStatus: Bool) {
        self.isHelping = NSNumber(value: helpStatus)
        self.mentor = mentor
    }
    
    func updateModifiedTime() {
        self.modified = Date()
        CoreDataHelpers.saveContext()
    }
    
    func pushChatItem(chat: Chat) {
        chat.helpQ = self // Set this object as the head
        
        let mutableVersion = self.chats.mutableCopy() as! NSMutableOrderedSet
        mutableVersion.add(chat)
        self.chats = mutableVersion
        CoreDataHelpers.saveContext() // Save after changing item
    }

}
