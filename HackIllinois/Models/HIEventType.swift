//
//  HIEventType.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 4/3/21.
//  Copyright © 2021 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation

struct HIEventType: CustomStringConvertible {
    var type: String
    var description: String {
        if type == "QNA" {
            return "COMPANY Q&A"
        } else {
            return type
        }
    }
}
