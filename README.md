# iOS

Official iOS apps for HackIllinois. Please read this README before continuing.

## Branch Information #

### master
Master only hosts released versions of the Hackillinois application. Currently 1.0 build(3)

### dev
Dev hosts a semi-stable version of the next release and all work should be done on branches off dev and commited via PR's.

## Requirements #
1. Cocoapods
2. XCode 9
3. Swift 4
4. iOS 11.0


## Installation #

``` shell
git clone https://github.com/HackIllinois/iOS.git
cd iOS
pod install
open Hackillinois.xcworkspace
```

Remember you must use the .xcworkspace file for development, rather than the .xcodeproj file.
