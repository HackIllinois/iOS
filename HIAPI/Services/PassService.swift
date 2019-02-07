//
//  PassService.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 2/22/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import APIManager

public final class PassService: BaseService {
    public override static var baseURL: String {
        return "https://passgen.hackillinois.org/pkpass"
    }

    public static func getPass(with msg: String) -> APIRequest<Data> {
        var params = HTTPParameters()
        params["message"] = msg
        return APIRequest<Data>(service: self, endpoint: "", body: params, method: .POST)
    }
}

extension Data: APIReturnable {
    public init(from data: Data) throws {
        self = data
    }
}
