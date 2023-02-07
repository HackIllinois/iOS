//
//  Array.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 2/6/23.
//  Copyright © 2023 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation

extension Array where Element == UInt8 {
    var deobfuscated: [UInt8] {
        let pre = prefix(count / 2)
        let post = suffix(count / 2)
        return zip(pre, post).map(^)
    }
}

