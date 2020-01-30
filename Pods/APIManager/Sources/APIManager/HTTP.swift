//
//  HTTP.swift
//  APIManager
//
//  Created by Rauhul Varma on 4/21/17.
//  Copyright © 2017 Rauhul Varma. All rights reserved.
//

/// An `HTTPBody` is the data transmitted in an HTTP message immediately
/// following the headers. Most HTTP requests with bodies use the `POST` or
/// `PUT` `HTTPMethod`.
public typealias HTTPBody = [String: Any]

/// `HTTPcookies` are small pieces of data that a server sends to the client to
/// store, to provide with future requests.
public typealias HTTPCookies = [AnyHashable: Any]

/// `HTTPHeaders` are components of the header section of request and response
/// messages. They define the operating parameters of an `APIRequest`.
public typealias HTTPHeaders = [String: String]

/// Enumeration of available HTTP methods.
public enum HTTPMethod: String {
    /// The GET method requests a representation of the specified resource.
    /// Requests using GET should only retrieve data.
    case GET
    /// The HEAD method asks for a response identical to that of a GET request,
    /// but without the response body.
    case HEAD
    /// The POST method is used to submit an entity to the specified resource,
    /// often causing a change in state or side effects on the server.
    case POST
    /// The PUT method replaces all current representations of the target
    /// resource with the request payload.
    case PUT
    /// The DELETE method deletes the specified resource.
    case DELETE
    /// The OPTIONS method is used to describe the communication options for the
    /// target resource.
    case OPTIONS
    /// The PATCH method is used to apply partial modifications to a resource.
    case PATCH
}

/// `HTTPParameters` are set of querys used to access specific data via an
/// `APIRequest`. These parameters will be postpended to a url in the form
/// `?key1=value1&key2=value...` etc.
public typealias HTTPParameters = [String: String]
