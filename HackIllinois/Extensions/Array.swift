//
//  Array.swift
//  HackIllinois
//
//  Created by Louis Qian on 2/6/23.
//  Copyright © 2023 HackIllinois. All rights reserved.
//

import Foundation

extension Array where Element == UInt8 {
    var deobfuscated: [UInt8] {
        let a = prefix(count / 2)
        let b = suffix(count / 2)
        return zip(a, b).map(^)
    }
}
