# RMRoute

[![CocoaPods Compatible](https://img.shields.io/cocoapods/p/RMRoute.svg)](https://img.shields.io/cocoapods/p/RMRoute.svg)
[![Twitter](https://img.shields.io/twitter/follow/roadmaptravel.svg?style=social&label=Follow)](http://twitter.com/roadmaptravel)

RMRoute is a lightweight implementation to use routes in your iOS application.

- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
    - **Intro -** [Making a Request](#making-a-request), [Response Handling](#response-handling), [Response Validation](#response-validation), [Response Caching](#response-caching)
- [Credits](#credits)
- [License](#license)

## Requirements

- iOS 8.0+
- Xcode 8.0+
- Swift 2.3

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

> CocoaPods 1.0.0+ is required to build RMRoute.

To integrate Alamofire into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'RMRoute'
end
```

Then, run the following command:

```bash
$ pod install
```

### Manually

If you prefer not to use either of the aforementioned dependency managers, you can integrate Alamofire into your project manually.

---

## Usage