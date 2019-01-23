//
//  HIAPIAttendee.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 2/7/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import APIManager

struct HIAPIAttendee: Codable, APIReturnable {
    var id: String
    var firstName: String?
    var lastName: String?
    var email: String
    var shirtSize: String
    var diet: HIDietaryRestrictions?
    var age: Int16
    var graduationYear: Int16
    var transportation: String
    var school: String
    var major: String
    var gender: String
    var professionalInterest: String?
    var github: String?
    var linkedin: String?
    var interests: [String]?
    var isBeginner: Bool?
    var isPrivate: Bool?
    var phone: String
    var longforms: [[String: String]]?
    var extraInfos: [[String: String]]?
    var osContributors: [[String: String]]?
    var collaborators: [[String: String]]?
}
