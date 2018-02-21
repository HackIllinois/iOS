//
//  Themeable.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 2/21/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//

import Foundation

protocol Themeable {
    associatedtype Style
    var style: Style { get }
    func refreshForThemeChange()
}
