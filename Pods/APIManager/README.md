# APIManager
[![Swift Version](https://img.shields.io/badge/swift-v4.2-orange.svg)](https://github.com/apple/swift)
[![Build Status](https://travis-ci.org/rauhul/api-manager.svg?branch=master)](https://travis-ci.org/rauhul/api-manager)
[![Documentation Converage](https://raw.githubusercontent.com/rauhul/api-manager/master/docs/badge.svg?sanitize=true)](https://rauhul.me/api-manager/)
[![Release Version](https://img.shields.io/badge/release-v0.2.0-ff69b4.svg)](https://github.com/rauhul/api-manager/releases)
[![GitHub License](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/rauhul/api-manager/master/LICENSE)

APIManager is a framework for abstracting RESTful API requests.

## Requirements
- iOS 11.0+
- Swift 4.2+

## Installation

### CocoaPods
[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

> CocoaPods 1.0.0+ is required to build APIManager.

To integrate APIManager into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '11.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'APIManager', '~> 0.3.0'
end
```

Then, run the following command:

```bash
$ pod install
```

#### Note
APIManager 0.0.5 is the last release with Swift 3 support

### Swift Package Manager
The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler.

Once you have your Swift package set up, adding APIManager as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .Package(url: "https://github.com/rauhul/api-manager.git", from: "0.3.0")
]
```

## Usage
APIManager relies on users to create `APIServices` and  `APIReturnable` types relevent to the RESTful APIs they are working with. `APIServices` contain descriptions of various endpoints that return their responses as native swift objects.

### Making an APIReturnable Type

An APIReturnable Type only needs to conform to one method  `init(from: Data) throws`. APIManager extends `Decodable` types to also be `APIReturnable`. An example implementation can be found below:

```swift
extension APIReturnable where Self: Decodable {
    init(from data: Data) throws {
        self = try JSONDecoder().decode(Self.self, from: data)
    }
}
```

### Making an APIService
An APIService is made up of 3 components.

1. A `baseURL`. Endpoints in this service will be postpended to this URL segment. As a result a baseURL will generally look like the root URL of the API the service communicates with.

```swift
open class var baseURL: String {
    return "https://api.example.com"
}
```

2. `HTTPHeaders` to be sent alongside the `APIRequest`s made by the endpoints in your `APIService`.

```swift
open class var headers: HTTPHeaders? {
    return [
        "Content-Type": "application/json"
    ]
}

```

3. A set of RESTful api endpoints that you would like to use. These should be simple wrappers around the `APIRequest` constructor that can take in data (as `HTTPParameters` and/or `HTTPBody` as a json dictionary `[String: Any]`). For example if you would like to get user information by id, the endpoint may look like this:

```swift
open class func getUser(byId id: Int) -> APIRequest<ExampleReturnType> {
    return APIRequest<ExampleReturnType>(service: Self, endpoint: "/users", params: ["id": id], body: nil, method: .GET)
}

```

### Using an APIService
Now that you have an `APIService`, you can use it make RESTful API Requests.

All the RESTful API endpoints we need to access should already be defined in our `APIService`, so using them is simply a matter of calling them.

Using the example service above, we can make a request to get the User associated with the id 452398:

```swift
let request = ExampleService.getUser(byId: 452398)
```

And subsecquently perform the `APIRequest` with:

```swift 
request.perform(withAuthorization: nil)
```

However, this leaves us unable to access the response nor potential error and additionally requires multiple lines to do what is really one action. Conveniently `APIManager` allows us to solve this problems with simple chaining syntax. We can specify success, cancellation, and failure blocks. This new request is seen below:

```swift
ExampleService.getUser(byId: 452398)
.onSuccess { (returnValue: ReturnType) in
    // Handle Success (Background thread)
    DispatchQueue.main.async {
        // Handle Success (main thread)
    }
}
.onFailure { (error) in
    // Handle Failure (Background thread)
    DispatchQueue.main.async {
        // Handle Failure (main thread)
    }
}
.perform(withAuthorization: nil)
```

## Support
Please [open an issue](https://github.com/rauhul/api-manager/issues/new) for support.

## Contributing
Please contribute using [Github Flow](https://guides.github.com/introduction/flow/). Create a branch, add commits, and [open a pull request](https://github.com/rauhul/api-manager/compare/).

## License
This project is licensed under the MIT License. For a full copy of this license take a look at the LICENSE file.
