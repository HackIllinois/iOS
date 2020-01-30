//
//  APIAuthorization.swift
//  APIManager
//
//  Created by Rauhul Varma on 4/21/17.
//  Copyright © 2017 Rauhul Varma. All rights reserved.
//

/// `APIAuthorization` defines all the properties and methods a class must
/// contain to be used as an authorization for an `APIRequest`.
public protocol APIAuthorization {

    /// Configuration point for an `APIAuthorization` to inject additional
    /// parameters into a request.
    func parametersFor<ReturnType>(request: APIRequest<ReturnType>) -> HTTPParameters?
    /// Configuration point for an `APIAuthorization` to inject additional body
    /// components into a request.
    func bodyFor<ReturnType>(request: APIRequest<ReturnType>) -> HTTPBody?
    /// Configuration point for an `APIAuthorization` to inject additional
    /// headers into a request.
    func headersFor<ReturnType>(request: APIRequest<ReturnType>) -> HTTPHeaders?
}

public extension APIAuthorization {
    /// Placeholder implementation, returns nil.
    public func parametersFor<ReturnType>(request: APIRequest<ReturnType>) -> HTTPParameters? { return nil }
    /// Placeholder implementation, returns nil.
    public func bodyFor<ReturnType>(request: APIRequest<ReturnType>) -> HTTPBody? { return nil }
    /// Placeholder implementation, returns nil.
    public func headersFor<ReturnType>(request: APIRequest<ReturnType>) -> HTTPHeaders? { return nil }
}
