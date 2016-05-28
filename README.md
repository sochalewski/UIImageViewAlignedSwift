# UIImageViewAlignedSwift

[![Version](https://img.shields.io/cocoapods/v/UIImageViewAlignedSwift.svg?style=flat)](http://cocoapods.org/pods/UIImageViewAlignedSwift)
[![License](https://img.shields.io/cocoapods/l/UIImageViewAlignedSwift.svg?style=flat)](http://cocoapods.org/pods/UIImageViewAlignedSwift)
[![Platform](https://img.shields.io/cocoapods/p/UIImageViewAlignedSwift.svg?style=flat)](http://cocoapods.org/pods/UIImageViewAlignedSwift)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
Swift 2.x, iOS 8+

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate UIImageViewAlignedSwift into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

pod 'UIImageViewAlignedSwift', '~> 0.1'
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

To integrate UIImageViewAlignedSwift into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "sochalewski/UIImageViewAlignedSwift" ~> 0.1
```

Run `carthage update` to build the framework and drag the built `UIImageViewAlignedSwift.framework` into your Xcode project.

## What is it?

It is a subclass of `UIImageView` that allows you to customize the alignment of the displayed image inside the view's frame.
This works even if the `contentMode` is set to `AspectFit`, `AspectFill` or `ScaleToFill`.

It is rewritten to Swift based on original [UIImageViewAligned by reydanro](https://github.com/reydanro/UIImageViewAligned).

## Why a subclass of UIImageView, and not a standard UIView?

Because there are many cool categories built on top of `UIImageView`. Subclassing a standard `UIView` would mean losing them.

For example, `AFNetworking`'s async `UIImageView` category works perfectly using this container class, and you don't have to worry about a thing.


## How does it work?

When initialized, `UIImageViewAligned` will create a inner `UIImageView` which will actually hold the image displayed.
The main class then just repositions this inner `UIImageView` to achieve your desired alignment.

At runtime, you can change the `image`, `contentMode` or `alignment` and the image will reposition itself correctly.

The `image` property of `UIImageViewAligned` is overwritten to forward the calls to the inner `UIImageView`, so you can just drag and drop into your app.

## Author

Sunshinejr, thesunshinejr@gmail.com, <a href="https://twitter.com/thesunshinejr">@thesunshinejr</a>

## License

UIImageViewAlignedSwift is available under the MIT license. See the LICENSE file for more info.
