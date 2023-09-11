# AccessoryKit

A customizable, expandable, and easy-to-use input accessory view component for iOS.

[![Version](https://img.shields.io/cocoapods/v/AccessoryKit.svg?style=flat)](https://cocoapods.org/pods/AccessoryKit)
[![License](https://img.shields.io/cocoapods/l/AccessoryKit.svg?style=flat)](https://cocoapods.org/pods/AccessoryKit)
[![Platform](https://img.shields.io/cocoapods/p/AccessoryKit.svg?style=flat)](https://cocoapods.org/pods/AccessoryKit)

## Features

**AccessoryKit** aims to provide a customizable, expandable and easy-to-use input accessory view. This component is developed for and is currently used in my app [MDNotes](https://apps.apple.com/us/app/mdnotes/id1471287219).

![](Screenshots/1.png)

The main features are:

* Responsively uses `UITextInputAssistantItem` on iPad and `UITextInputView` on iPhone.
* Scrollable input accessory view with blurry background and customizable buttons.
* Grouping buttons into a visually related button group.
* Supports Auto Layout and Safe Area.
* Supports dark mode.
* Provides built-in pre-defined buttons with SF Symbol.
* Supports presenting `UIMenu` on input accessory view.
* Control state of identified buttons independently.

## Usage

### Requirements

* iOS 14.0+
* Swift 5.7+

### Installation

#### Swift Package Manager

AccessoryKit is available as a Swift Package. Add this repo to your project through Xcode GUI or `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/xnth97/AccessoryKit.git", .upToNextMajor(from: "2.0.0"))
]
```

#### CocoaPods

To install AccessoryKit, simply add the following line to your Podfile:

```ruby
pod 'AccessoryKit'
```

### Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

### API

```swift
// Create view model array of key button groups
let keyButtonGroups: [KeyboardAccessoryButtonGroup] = [
    // Group is just an array of `KeyboardAccessoryButton`. Group elements will be visually 
    // grouped and close to each other.
    [
        // Create button with built-in type and tap handler block that will be placed on 
        // the leading side of keyboard on iPad
        KeyboardAccessoryButton(type: .undo, position: .leading) { [weak self] in
            self?.undo()
        },
        // Create button with UIImage that will be collapsed in an overflow menu on iPad
        KeyboardAccessoryButton(image: UIImage(named: "img"), position: .overflow),
    ],
    [
        // Create button with title
        KeyboardAccessoryButton(title: "Button"),
        // Create button with UIMenu
        KeyboardAccessoryButton(type: .link, menu: createInsertMenu()),
    ],
]

// Initialize and retain `KeyboardAccessoryManager`
self.accessoryManager = KeyboardAccessoryView(
    keyButtonGroups: keyButtonGroups,
    showDismissKeyboardKey: true,
    delegate: self)

// Configures the `UITextView` with `KeyboardAccessoryManager`
self.accessoryManager.configure(textView: textView)
```

## License

AccessoryKit is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
