//
//  HIGroupStatusOptions.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 3/3/21.
//  Copyright © 2021 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation

struct HIGroupStatusOptions {
    var status = ""
    var selected = false
    init(name: String, selected: Bool) {
        self.status = name
        self.selected = selected
    }
}
