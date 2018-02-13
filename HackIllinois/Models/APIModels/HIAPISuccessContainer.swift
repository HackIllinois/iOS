//
//  HIAPISuccessContainer.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 1/28/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//

import Foundation
import APIManager

struct HIAPISuccessContainer: Decodable, APIReturnable {
    let meta: String?
    let error: Error?

    struct Error: Decodable {
        let type: String
        let status: Int
        let title: String
        let message: String
        let source: String
    }
}
