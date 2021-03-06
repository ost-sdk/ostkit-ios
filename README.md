[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/OSTKit.svg)](https://img.shields.io/cocoapods/v/OSTKit.svg) [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) [![Swift Package Manager compatible](https://img.shields.io/badge/SPM-compatible-brightgreen.svg?style=flat&colorA=28a745&&colorB=4E4E4E)](https://github.com/apple/swift-package-manager)

[![Platform](https://img.shields.io/badge/Platforms-iOS%20%7C%20macOS%20%7C%20watchOS%20%7C%20tvOS%20%7C%20Linux-4E4E4E.svg?colorA=28a745)](#installation)

[![Build Status](https://travis-ci.org/ost-sdk/ostkit-ios.svg?branch=travis-ci-integration)](https://travis-ci.org/ost-sdk/ostkit-ios)



OSTKit is an api wrapper written in swift for [ost kit](https://ost.com) . The complete blockchain toolkit for business

## Requirements

- iOS 9.0+
- Xcode 9.3+
- Swift 4.0+

## Installation
### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

> CocoaPods 1.1+ is required to build OSTKit 4.0+.

To integrate OSTKit into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'OSTKit', '~> 0.0.5'
end
```

Then, run the following command:

```bash
$ pod install
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate OSTKit into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "ost-sdk/ostkit-ios" ~> 0.0.9
```

Run `carthage update` to build the framework and drag the built `ostkit.framework` into your Xcode project.

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler. 

Once you have your Swift package set up, adding OSTKit as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/ost-sdk/ostkit-ios.git", from: "0.0.8")
]
```

## Usage

### Initialize SDK
```swift
import ostkit
let sdk = OSTSDK(
	baseURLString: BASE_URL_STRING, 
	key: API_KEY, 
	serect: API_SECRET, 
	debugMode: true
)
```

### Create and listing user
```swift
/// create user services instance
let userServices = sdk.userServices()

/// create user
userServices.create(name: 'steve') {
	[weak self] response in
	guard let strongSelf = self else { return }
	switch response {
	case .success(let user):
		debugPrint(user)
	case .failure(let error):
		debugPrint(error)
	}
}

/// listing user
userServices.list {
	[weak self] response in
	guard let strongSelf = self else { return }
	switch response {
	case .success(let json):
		if let data = json["data"] as? [String: Any] {
			let users = data["economy_users"] as? [[String: Any]] ?? []
		}
	case .failure(let error):
		debugPrint(error)
	}
}
```

### Create and listing transaction type
```swift
/// create transaction type services instance
let services = sdk.transactionServices()

/// create 
let kind = TransactionTypeServices.Kind.userToUser
let type = TransactionTypeServices.CurrencyType.bt
services.create(name: 'Upvote', kind: kind, 
currencyType: type, currencyValue: 0.1, commissionPercent: 10) {
	[weak self] response in
	guard let strongSelf = self else { return }
	switch response {
	case .success(let user):
		debugPrint(user)
	case .failure(let error):
		debugPrint(error)
	}
}

/// listing 
services.list {
	[weak self] response in
	guard let strongSelf = self else { return }
	switch response {
	case .success(let json):
		if let data = json["data"] as? [String: Any] {
			let trans = data["transaction_types"] as? [[String: Any]] ?? []
		}
	case .failure(let error):
		debugPrint(error)
	}
}
```

## Author

OSTKit is owned by @vanductai and maintained by @duong1521991

You can contact me at email [duong1521991@gmail.com]()


