//
//  HIBaseService.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 11/16/17.
//  Copyright © 2017 HackIllinois. All rights reserved.
//

import Foundation
import APIManager

class HIBaseService: APIService {

    class var baseURL: String {
        return "http://ec2-107-20-14-41.compute-1.amazonaws.com/v1"
    }

    class var headers: HTTPHeaders? {
        return [
            "Content-Type": "application/json",
            "Authorization": HIBaseService.authorizationKey
        ]
    }

    static var authorizationKey = "Basic eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6InN5c3RlbXNAaGFja2lsbGlub2lzLm9yZyIsInJvbGVzIjpbeyJyb2xlIjoiQURNSU4iLCJhY3RpdmUiOjF9XSwiaWF0IjoxNTExMTU1NTg4LCJleHAiOjE1MTE3NjAzODgsInN1YiI6IjEifQ.NiM9JsS5MQ5wcG7DG3gO_rF3m2i7E-dueg7NuJGEGTE"

}
