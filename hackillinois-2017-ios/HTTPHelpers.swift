//
//  HTTPHelpers.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 6/21/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

import Foundation
import SwiftyJSON

/* Contains helpers for HTTP Requests to backend */
class HTTPHelpers {
    /*
     * Higher order function used to help facilitate consistency between how request process is handled.
     */
    class func createRequest(subUrl url: String, jsonPayload: JSON, requestConfiguration: ((NSMutableURLRequest) -> Void), completion: @escaping (Data?, URLResponse?, NSError?) -> Void) {
        /* Load HackIllinois API URL from App Delegate */
        print("url: \(url)")
        let hackillinois_url = (UIApplication.shared.delegate as! AppDelegate).HACKILLINOIS_API_URL + url
        print("Fetching data from: \(hackillinois_url)")
        do {
            /* Create JSON payload */
            let payload = try jsonPayload.rawData()
            /* Create and configure request */
            let request = NSMutableURLRequest(url: URL(string: hackillinois_url)!)
            requestConfiguration(request)
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.httpBody = payload
            
            let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
                if error != nil {
                    print("Session Error: \(error)")
                    return
                }
                
                completion(data, response, error as NSError?)
            }
            
            task.resume()
        } catch {
            print("Failed to encode JSON to NSData")
            print(error)
        }
    }
    
    /*
     * Creates a POST request for the requested subdirectory url (v1/auth, etc.)
     * The data returned is captured in the completion function, where you can use to process information such as any errors (server is dead), response headers, etc.
     * For GET requests, see createGetRequest
     */
    class func createPostRequest(subUrl url: String, jsonPayload: JSON, completion: @escaping (Data?, URLResponse?, NSError?) -> Void) {
        createRequest(subUrl: url, jsonPayload: jsonPayload, requestConfiguration: { $0.httpMethod = "POST" }, completion: completion)
    }
    
    /*
     * Creates a GET request for the requested subdirectory url (v1/auth, etc)
     * The data returned is captured in the completion function, which you can use to process information such as any errors (server is dead), response headers, etc.
     * For POST requests, see createPostRequest
     */
    class func createGetRequest(subUrl url: String, jsonPayload: JSON, completion: @escaping (Data?, URLResponse?, NSError?) -> Void) {
        createRequest(subUrl: url, jsonPayload: jsonPayload, requestConfiguration: { $0.httpMethod = "GET" }, completion: completion)
    }
}
