//
//  APIRequest.swift
//  APIManager
//
//  Created by Rauhul Varma on 4/14/18.
//  Copyright © 2018 Rauhul Varma. All rights reserved.
//

import Foundation

public extension OperationQueue {
    /// Default `OperationQueue` for running requests. Other queues can be used
    /// via `APIRequest.launch(on:)`.
    public static let defaultAPIRequestQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 10
        return queue
    }()
}

/// Enumeration of the Errors that can occur during an `APIRequest`.
public enum APIRequestError: Error {
    /// Error occuring when a request gets a response with an invalid
    /// response code; provides a decription of the error code.
    case invalidHTTPReponse(code: Int, description: String)
    /// Error occuring when a request encounters an inconsistancy it does
    /// not know how to handle; provides a decription of the error.
    case internalError(description: String)
    /// Error occuring when a request is cancelled.
    case cancelled
}

/// Enumeration of the states of an `APIRequest`.
@objc private enum APIRequestState: Int {
    /// State indicating the request is ready to be performed.
    case ready
    /// State indicating the request is executing.
    case executing
    /// State indicating the request has finished executing.
    case finished
}

/// Base class for creating an APIRequest.
/// - note: `APIRequest`s should be created through a class that conforms to
/// `APIService`.
open class APIRequest<ReturnType: APIReturnable>: Operation {

    // MARK: - Types & Aliases
    /// Alias for the callback when an request completes.
    public typealias Completion = (Result<(ReturnType, HTTPCookies)>) -> Void

    // MARK: - Implemenation Properties
    /// DispatchQueue used to serialize access to `state`.
    private let stateQueue = DispatchQueue(label: "com.rauhul.APIManager.stateQueue", attributes: .concurrent)
    /// Tracks state of the request; backs `state` property.
    private var _state: APIRequestState = .ready
    /// Objective-C visible setter and getter for `_state`.
    @objc private dynamic var state: APIRequestState {
        get { return stateQueue.sync { _state } }
        set { stateQueue.sync(flags: .barrier) { _state = newValue } }
    }
    /// A Boolean value indicating whether the request can be performed now.
    open         override var isReady: Bool { return state == .ready && super.isReady }
    /// A Boolean value indicating whether the request is currently executing.
    public final override var isExecuting: Bool { return state == .executing }
    /// A Boolean value indicating whether the request has finished executing.
    public final override var isFinished: Bool { return state == .finished }
    /// A Boolean value indicating the request executes asynchronously.
    public final override var isAsynchronous: Bool { return true }
    /// The `URLSessionDataTask` backing the request.
    private var dataTask: URLSessionDataTask?

    // MARK: - Request Properties
    /// The endpoint for the request relative to the baseURL of the service.
    public let endpoint: String
    /// The http method for the request.
    public let method: HTTPMethod
    /// The url parameters for the request.
    public let parameters: HTTPParameters?
    /// The json body for the request.
    public let body: HTTPBody?
    /// The http headers for the request.
    public let headers: HTTPParameters?
    /// The `APIService` the request is part of.
    public let service: APIService.Type
    /// The object used to authorize the request.
    open private(set) var authorization: APIAuthorization?
    /// The callback on a completed request, called with the result.
    open private(set) var completion: Completion?

    // MARK: - Private API
    /// Registers the dependent keys for `isReady`.
    @objc private dynamic class func keyPathsForValuesAffectingIsReady() -> Set<String> { return [#keyPath(state)] }
    /// Registers the dependent keys for `isExecuting`.
    @objc private dynamic class func keyPathsForValuesAffectingIsExecuting() -> Set<String> { return [#keyPath(state)] }
    /// Registers the dependent keys for `isFinished`.
    @objc private dynamic class func keyPathsForValuesAffectingIsFinished() -> Set<String> { return [#keyPath(state)] }

    /// Creates a `URLRequest` representing the request.
    private func formURLRequest() throws -> URLRequest {
        let parameters = Dictionary(service.parameters, self.parameters, authorization?.parametersFor(request: self))
        let body = Dictionary(service.body, self.body, authorization?.bodyFor(request: self))
        let headers = Dictionary(service.headers, self.headers, authorization?.headersFor(request: self))

        var urlString = service.baseURL + endpoint
        if !parameters.isEmpty {
            urlString += "?" + parameters.map { return "\($0)=\($1)" }.joined(separator: "&")
        }

        guard let url = URL(string: urlString) else {
            throw APIRequestError.internalError(description: "Failed to form url from \(urlString) for request")
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        if !body.isEmpty {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        }

        for (field, value) in headers {
            request.addValue(value, forHTTPHeaderField: field)
        }

        return request
    }

    /// The completion handler for the `URLSessionDataTask` backing the request.
    private func urlRequestCallback(data: Data?, response: URLResponse?, error: Error?) {
        if let error = error {
            if (error as NSError).code == NSURLErrorCancelled {
                completion?(.failure(APIRequestError.cancelled))
            } else {
                completion?(.failure(error))
            }
        } else if let response = response as? HTTPURLResponse, let data = data {
            let result = Result { () -> (ReturnType, HTTPCookies) in
                try service.validate(statusCode: response.statusCode)
                return (try ReturnType.init(from: data), response.allHeaderFields)
            }
            completion?(result)
        } else {
            completion?(.failure(APIRequestError.internalError(description: "Unable parse returned data.")))
        }
        state = .finished
    }

    /// Starts the request, this method should only be called by an
    /// `OperationQueue`. Instead, use `launch()`, `launch(on:)`, or add this
    /// object to an `OperationQueue` to begin the request.
    public final override func start() {
        if isCancelled {
            completion?(.failure(APIRequestError.cancelled))
            return
        }

        state = .executing
        do {
            let urlRequest = try formURLRequest()
            dataTask = URLSession.shared.dataTask(with: urlRequest, completionHandler: urlRequestCallback)
            dataTask?.resume()
        } catch {
            completion?(.failure(error))
            state = .finished
        }
    }

    // MARK: - Public API
    /// Creates a new `APIRequest`.
    /// - parameters:
    ///     - endpoint: The api endpoint relative to the baseURL of the service.
    ///     - params:   Optional url parameters for the request.
    ///     - body:     Optional json body for the request.
    ///     - body:     Optional http headers for the request.
    ///     - method:   The method for the request.
    /// - note: Only to be used by a class that conforms to `APIService`.
    public init(service: APIService.Type,
                endpoint: String,
                params: HTTPParameters? = nil,
                body: HTTPBody? = nil,
                headers: HTTPHeaders? = nil,
                method: HTTPMethod) {
        self.service = service
        self.endpoint = endpoint
        self.body = body
        self.parameters = params
        self.headers = headers
        self.method = method
    }

    /// Sets the authorization for an request.
    /// - parameters:
    ///     - authorization: The object used to authorize the request.
    /// - returns: `self` for method chaining as needed.
    @discardableResult
    open func authorize(with authorization: APIAuthorization?) -> APIRequest {
        self.authorization = authorization
        return self
    }

    /// Sets the callback on a completed request, called with the result.
    /// - parameters:
    ///     - comepletion: The block to be called on a completed request.
    /// - returns: `self` for method chaining as needed.
    @discardableResult
    open func onCompletion(_ completion: Completion?) -> APIRequest {
        self.completion = completion
        return self
    }

    /// Launches the request and calls the completion handler once the finished.
    /// - parameters:
    ///     - queue: The OperationQueue to run the request on, will be run the
    /// default queue if none is specified.
    /// - returns: `self` for method chaining as needed.
    @discardableResult
    open func launch(on queue: OperationQueue = .defaultAPIRequestQueue) -> APIRequest {
        queue.addOperation(self)
        return self
    }

    /// Cancels an in-flight request.
    open override func cancel() {
        dataTask?.cancel()
        super.cancel()
    }
}
