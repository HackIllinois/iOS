//
//  Attendee.swift
//  HIAPI
//
//  Created by HackIllinois Team on 2/3/19.
//  Copyright © 2019 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import APIManager
import Foundation

public struct AttendeeContainer: Codable, APIReturnable {
    public let attendee: Attendee
}

public struct Attendee: Codable, APIReturnable {
    public let id: String
    public let firstName: String?
    public let lastName: String?
    public let email: String
    public let shirtSize: String
    public let diet: DietaryRestrictions
    public let age: Int
    public let graduationYear: Int
    public let transportation: String
    public let school: String
    public let major: String
    public let gender: String
    public let professionalInterest: [String]?
    public let github: String
    public let linkedin: String?
    public let interests: [String]?
    public let phone: String
}
