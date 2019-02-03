# iOS ![HackIllinois](https://raw.githubusercontent.com/HackIllinois/iOS/sujay/update-readme/.github/hi-logo.png)

Official iOS app for HackIllinois. Please read this README before continuing.

## Branch Information #

### master [![Build Status](https://travis-ci.com/HackIllinois/iOS.svg?branch=master)](https://travis-ci.com/HackIllinois/iOS)
Master only hosts released versions of the Hackillinois application. Currently 1.0.1 build(1).

### dev [![Build Status](https://travis-ci.com/HackIllinois/iOS.svg?branch=dev)](https://travis-ci.com/HackIllinois/iOS)
Dev hosts a semi-stable version of the next release and all work should be done on branches off dev and commited via PR's.

## Requirements #
1. Cocoapods
2. XCode 10
3. Swift 4.2
4. iOS 11.0


## Installation #

``` shell
git clone https://github.com/HackIllinois/iOS.git
cd iOS
pod install
open Hackillinois.xcworkspace
```

Remember you must use the .xcworkspace file for development, rather than the .xcodeproj file.
