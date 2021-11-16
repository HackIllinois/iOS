//  HackIllinois
//
//  Created by HackIllinois Team on 11/16/21.
//  Copyright © 2021 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import APIManager

public struct LeaderboardProfileContainer: Decodable, APIReturnable {
    public let profiles: [LeaderboardProfile]
    
    public init(from data: Data) throws {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        self = try decoder.decode(LeaderboardProfileContainer.self, from: data)
    }
}

public struct LeaderboardProfile: Codable, APIReturnable {
    public let id: String
    public let firstName: String
    public let lastName: String
    public let points: Int
}
