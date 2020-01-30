//
//  APIService.swift
//  APIManager
//
//  Created by Rauhul Varma on 4/21/17.
//  Copyright © 2017 Rauhul Varma. All rights reserved.
//

import Foundation

/// `APIService` defines all the properties and methods a class must contain to be used as a service in an `APIRequest`.
///
/// A class that conforms to APIService should also define all the endpoints relevent to that service.
///
/// An endpoint might look like:
/// ```
/// open class func getUser(byId id: String) -> APIRequest<ReturnType> {
///     return APIRequest<ReturnType>(endpoint: "/users", params: nil, body: ["id": id], method: .GET)
/// }
/// ```
public protocol APIService {

    /// The base URL for this `APIService`.
    ///
    /// Endpoints in this service will be postpended to this URL segment. As a result a baseURL will generally look like the root URL of the API the service communicates with.
    ///
    /// A baseURL might look like: ```https://api.example.com``` with endpoints like: ```/users``` or ```/schedule```
    ///
    /// When interacting with more complicated APIs, it may be necessary to create subclasses of your service in order to maintain clean and readable code. In these cases the super-service should still have a baseURL as defined above. However the sub-services should have baseURLs of the form:
    ///
    /// ```
    /// override open class var baseURL: String {
    ///     return super.baseURL + "/users"
    /// }
    /// ```
    static var baseURL: String { get }

    /// The `HTTPHeaders` to be sent alongside the `APIRequest`s made by the endpoints in this `APIService`.
    static var parameters: HTTPParameters? { get }

    /// The `HTTPHeaders` to be sent alongside the `APIRequest`s made by the endpoints in this `APIService`.
    static var body: HTTPBody? { get }

    /// The `HTTPHeaders` to be sent alongside the `APIRequest`s made by the endpoints in this `APIService`.
    static var headers: HTTPHeaders? { get }

    /// Offers an optional point for an `APIService` to determine what HTTPReponse status codes are valid. The default implementation marks any response with a status code in the range 200..<300 as valid.
    ///
    /// To change this behavior, simiply override this method and throw an APIRequestError.invalidHTTPReponse for any invalid response codes.
    static func validate(statusCode: Int) throws
}

/// Default implementations of APIService components
public extension APIService {
    /// The `HTTPHeaders` to be sent alongside the `APIRequest`s made by the endpoints in this `APIService`.
    static var parameters: HTTPParameters? { return nil }

    /// The `HTTPHeaders` to be sent alongside the `APIRequest`s made by the endpoints in this `APIService`.
    static var body: HTTPBody? { return nil }
    
    /// The `HTTPHeaders` to be sent alongside the `APIRequest`s made by the endpoints in this `APIService`.
    static var headers: HTTPHeaders? { return nil }

    /// Default implementation of validate that marks any response with a status code in the range 200..<300 as valid.
    public static func validate(statusCode: Int) throws {
        if !(200..<300).contains(statusCode) {
            let description = HTTPURLResponse.localizedString(forStatusCode: statusCode)
            throw APIRequestError.invalidHTTPReponse(code: statusCode, description: description)
        }
    }
}
