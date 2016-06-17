//
//  Chat.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 6/17/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

import Foundation

class Chat {
    var user: String // User that typed the Chat message
    var message: String // Message content
    var time: NSDate // When the user typed the message
    
    init() {
        user = "Shotaro Ikeda"
        message = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque venenatis mattis molestie. Ut vestibulum eget lorem convallis molestie. Nunc ultrices, justo mollis lobortis lacinia, quam orci aliquet nisi, lobortis vestibulum ex sapien et magna. Nulla feugiat id elit non dictum. Integer scelerisque malesuada suscipit. "
        time = NSDate()
    }
    
    init(user: String, message: String) {
        self.user = user
        self.message = message
        self.time = NSDate()
    }
    
    convenience init(user: String) {
        self.init()
        self.user = user
    }
}