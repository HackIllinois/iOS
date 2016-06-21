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
    class func createPostRequest(subUrl url: String, jsonPayload: JSON) -> JSON? {
        /* Load HackIllinois API URL from App Delegate */
        let hackillinois_url = (UIApplication.sharedApplication().delegate as! AppDelegate).HACKILLINOIS_API_URL + url
        print(hackillinois_url)
        do {
            /* Create JSON payload */
            let payload = try jsonPayload.rawData()
            /* Create and configure request */
            let request = NSMutableURLRequest(URL: NSURL(string: hackillinois_url)!)
            request.HTTPMethod = "POST"
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.HTTPBody = payload
            
            var jsonReturn: JSON!
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
                if let httpResponse = response as? NSHTTPURLResponse {
                    if httpResponse.statusCode == 404 {
                        print("404 not found")
                        jsonReturn = nil
                        return
                    }
                }
                
                if error != nil {
                    print("Session Error: \(error)")
                    return
                }
                
                jsonReturn = JSON(data: data!)
                /* Debug */
                print(response)
                print(jsonReturn)
            }
            
            task.resume()
            return jsonReturn
        } catch {
            print("Failed to encode JSON to NSData")
            print(error)
        }
        
        return nil
    }
}