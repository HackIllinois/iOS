//
//  Dictionary.swift
//  APIManager
//
//  Created by Rauhul Varma on 1/5/19.
//  Copyright © 2019 Rauhul Varma. All rights reserved.
//

import Foundation

internal extension Dictionary {
    /// Initializes a dictionary by combining the contents of an arbitrary
    /// number of dictionaries. In the case of colliding keys, the last
    /// dictionary's value will be used.
    internal init(_ dictionarys: Dictionary?...) {
        self.init()
        for dictionary in dictionarys {
            guard let dictionary = dictionary else { continue }
            for (key, value) in dictionary {
                self[key] = value
            }
        }
    }
}
