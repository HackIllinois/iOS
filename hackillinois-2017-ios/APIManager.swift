//
//  APIManager.swift
//  hackillinois-2017-ios
//
//  Created by Rauhul Varma on 2/16/17.
//  Copyright © 2017 Shotaro Ikeda. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class APIManager {
    static let shared = APIManager()
    
    private let HACKILLINOIS_API_URL = "https://api.hackillinois.org/"
    private var auth_header: [String: String]?
    
    private init() {
        
    }
    
    func setAuthKey(_ key: String) {
        auth_header = ["Authorization": key]
    }
    
    func deleteAuthKey() {
        auth_header = nil
    }
    
    func getAuthKey(username: String, password: String, success: ((JSON) -> Void)?, failure: ((Error) -> Void)?) {
        performRequest(endpoint: "v1/auth", method: .post, parameters: [
            "email": username,
            "password": password
        ], success: success, failure: failure)
    }
    
    func getUserInfo(success: ((JSON) -> Void)?, failure: ((Error) -> Void)?) {
        assert(auth_header != nil)
        performRequest(endpoint: "v1/registration/attendee", method: .get, parameters: nil, headers: auth_header, success: success, failure: failure)
    }
    
    
    private func performRequest(endpoint: String, method: HTTPMethod, parameters: [String: Any]?, headers: [String: String]? = nil, success: ((JSON) -> Void)?, failure: ((Error) -> Void)?) {
        let url = HACKILLINOIS_API_URL + endpoint
        Alamofire.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (reponse) in
            print(reponse)
            
            if reponse.result.isSuccess {
                let json = JSON(reponse.result.value!)
                success?(json)
            }
            
            if reponse.result.isFailure {
                failure?(reponse.result.error!)
            }
        }
    }
    
    
    
    
}
