# RMRoute

[![CocoaPods Compatible](https://img.shields.io/cocoapods/p/RMRoute.svg)](https://img.shields.io/cocoapods/p/RMRoute.svg)
[![Twitter](https://img.shields.io/twitter/follow/roadmaptravel.svg?style=social&label=Follow)](http://twitter.com/roadmaptravel)

RMRoute is a lightweight implementation to use routes in your iOS application.

- [Summary](#summary)
- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
    - **Registering routes -** [Simple registration (without parameters)](#simple-registration-(without-parameters)), [More advanced registration (with parameters)](#more-advanced-registration-(with-parameters))
    - **Calling routes -** [Making a Request](#making-a-request), [Response Handling](#response-handling), [Response Validation](#response-validation), [Response Caching](#response-caching)
- [Credits](#credits)
- [License](#license)

## Summary

RMRoute makes it easy to provide access to all your features from anywhere in your app. With bigger applications it's sometimes handy to have entry points to your features, without referencing to them by class.

## Features

- [x] Registering & calling routes
- [x] Pass parameters in route
- [ ] Named parameters

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

## Usage

### Registering a route

#### Simple registration (without parameters)

```swift
import RMRoute

RMRoute.register("about") { (delegate, animation, params) in
			
	// Just show the vc
	let vc = AboutViewController()
	delegate.animate(vc, animation: animation) // This is an UIViewController extension which handles the animation type
}
```

```objc
[RMRoute register:@"about" action:^(UIViewController *delegate, RMRouteAnimation animation, NSArray *params) {
		
	// Just show the vc
	AboutViewController *vc = [[AboutViewController alloc] init];
	[delegate animate:vc animation:animation]; // This is an UIViewController extension which handles the animation type
}];
```

#### More advanced registration (with parameters)

```swift
import RMRoute

RMRoute.register("faq/{itemId}") { (delegate, animation, params) in

	guard let itemId = params[0] as? String else {
		return
	}

	// Just show the vc
	let vc = FAQViewController(itemId)
	delegate.animate(vc, animation: animation)
}
```

```objc
[RMRoute register:@"faq/{itemId}" action:^(UIViewController *delegate, RMRouteAnimation animation, NSArray *params) {

	NSString *itemId = params[0];

	if (itemId.length == 0) return;
		
	// Just show the vc
	FAQViewController *vc = [[FAQViewController alloc] initWithItemId:itemId];
	[delegate animate:vc animation:animation];
}];
```

### Calling a route

#### Simple call (without parameters)

```swift
import RMRoute

RMRoute.navigate("about", delegate: self, animation: .push)
```

```objc
[RMRoute navigate:@"about" delegate:self animation:RMRouteAnimationpush];
```

#### More advanced calling (with parameters)

```swift
import RMRoute

RMRoute.navigate("faq/12", delegate: self, animation: .present)
```

```objc
[RMRoute navigate:@"faq/12" delegate:self animation:RMRouteAnimationpresent];
```

## Credits

Credits to the Roadmap team, to make this all possible!

## License



