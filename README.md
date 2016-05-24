# iphone-2017

Official iOS application for HackIllinois. Please read this README before continuing.

# Requirements #
The following requirements are required to develop this application.


These requirements are the newest at the time of writing.
	1. Cocoapods 1.0.0
	2. XCode 7.3.1 (7D1014)
	3. Apple Swift version 2.2 (swiftlang-703.0.18.8 clang-703.0.31)
	4. iOS 9.0 or greater

# Installation #

``` shell
$ cd /path/to/github/dir
$ pod install
$ open hackillinois-2017-ios.xcworkspace
```

Remember that you MUST open the .xcworkspace file and develop on that, rather than using the xcodeproj file.

# Usage / Contribution #
See keys.plist to insert API Keys.

When contibuting, please remember to ignore future changes to the keys.plist file

``` shell
$ cd /path/to/github/dir
$ git update-index --assume-unchanged hackillinois-2017-ios/keys.plist
```
