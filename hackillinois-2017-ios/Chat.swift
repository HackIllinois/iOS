//
//  Chat.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 6/21/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

import Foundation
import CoreData


class Chat: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    func initialize() {
        user = "Shotaro Ikeda"
        message = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque venenatis mattis molestie. Ut vestibulum eget lorem convallis molestie. Nunc ultrices, justo mollis lobortis lacinia, quam orci aliquet nisi, lobortis vestibulum ex sapien et magna. Nulla feugiat id elit non dictum. Integer scelerisque malesuada suscipit. "
        time = NSDate()
    }
    
    func initialize(user: String, message: String) {
        self.user = user
        self.message = message
        self.time = NSDate()
    }
    
    func initialize(user: String) {
        self.initialize()
        self.user = user
    }

}
