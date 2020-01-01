//
//  Favorite.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 12/31/19.
//  Copyright © 2019 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import APIManager

public struct Favorite: Codable, APIReturnable {
    public let favorites: Set<String>
    public let id: String
}
