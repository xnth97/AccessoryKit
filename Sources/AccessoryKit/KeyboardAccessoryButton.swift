//
//  KeyboardAccessoryButton.swift
//  AccessoryKit
//
//  Created by Yubo Qin on 9/13/20.
//

import UIKit

/// Position of keyboard accessory button. Only available on iPad.
public enum KeyboardAccessoryButtonPosition {
    /// Displayed as an independent button on the leading side of toolbar.
    case leading
    /// Displayed as an independent button on the trailing side of toolbar.
    case trailing
    /// Displayed as an inline menu option on the trailing side of toolbar.
    case overflow
}

/// Typealias for a group of `KeyboardAccessoryButton`s.
public typealias KeyboardAccessoryButtonGroup = [KeyboardAccessoryButton]

/// View model struct that represents a key button inside `KeyboardAccessoryView`.
public struct KeyboardAccessoryButton {

    /// Pre-defined types of key button.
    public enum ButtonType {
        case tab
        case undo
        case redo
        case header
        case bold
        case italic
        case code
        case delete
        case item
        case quote
        case link
        case image
    }

    // MARK: - Constants

    /// Default tint color for buttons.
    public static let defaultTintColor = UIColor { trait in
        if trait.userInterfaceStyle == .light {
            return UIColor.black
        } else {
            return UIColor.white
        }
    }

    private static let imageNameMap: [ButtonType: String] = [
        .tab: "increase.indent",
        .undo: "arrow.uturn.left",
        .redo: "arrow.uturn.right",
        .header: "number",
        .bold: "bold",
        .italic: "italic",
        .code: "chevron.left.slash.chevron.right",
        .delete: "strikethrough",
        .item: "list.bullet",
        .quote: "text.quote",
        .link: "link",
        .image: "photo",
    ]

    private static let titleMap: [ButtonType: String] = [
        .tab: "Tab",
        .undo: "Undo",
        .redo: "Redo",
        .header: "Header",
        .bold: "Bold",
        .italic: "Italic",
        .code: "Code",
        .delete: "Delete",
        .item: "Bullet",
        .quote: "Quote",
        .link: "Link",
        .image: "Image",
    ]

    // MARK: - Properties

    /// The identifier of this button.
    public let identifier: String?

    /// The image that is shown on the button.
    public let image: UIImage?

    /// The title that is shown on the button.
    public let title: String?

    /// The font of title label of button.
    public let font: UIFont?

    /// The tint color of button. Please note that this will be overriden if `KeyboardAccessoryView`
    /// sets tint color.
    public let tintColor: UIColor

    /// The position of keyboard accessory button. Only available on iPad.
    public let position: KeyboardAccessoryButtonPosition

    /// The tap handler that will be invoked when tapping the button.
    public let tapHandler: (() -> Void)?

    /// The menu that will be shown once button is tapped.
    public let menu: UIMenu?

    // MARK: - Initializers

    /// Initialize the view model of key button inside `KeyboardAccessoryView`.
    /// - Parameters:
    ///   - identifier: The identifier of this button.
    ///   - title: The title that is shown on the button.
    ///   - font: The font of title label of button.
    ///   - image: The image that is shown on the button.
    ///   - tintColor: The tint color of button. Only available on `UITextInputView`.
    ///   - position: The position of keyboard accessory button. Only available on iPad.
    ///   - menu: The menu that will be shown once button is tapped. Only available for iOS 14+.
    ///   - tapHandler: The tap handler that will be invoked when tapping the button.
    public init(identifier: String? = nil,
                title: String? = nil,
                font: UIFont? = nil,
                image: UIImage? = nil,
                tintColor: UIColor = Self.defaultTintColor,
                position: KeyboardAccessoryButtonPosition = .overflow,
                menu: UIMenu? = nil,
                tapHandler: (() -> Void)? = nil) {
        if title == nil && image == nil {
            fatalError("[AccessoryKit] Error: Must provide a title or an image for button.")
        }
        self.identifier = identifier
        self.title = title
        self.font = font
        self.image = image
        self.position = position
        self.tapHandler = tapHandler
        self.menu = menu
        self.tintColor = tintColor
    }

    /// Initialize the view model of key button with a given button type.
    /// - Parameters:
    ///   - identifier: The identifier of this button.
    ///   - type: Pre-defined button type.
    ///   - tintColor: The tint color of button.
    ///   - position: The position of keyboard accessory button. Only available on iPad.
    ///   - menu: The menu that will be shown once button is tapped
    ///   - tapHandler: The tap handler that will be invoked when tapping the button.
    public init(identifier: String? = nil,
                type: ButtonType,
                tintColor: UIColor = Self.defaultTintColor,
                position: KeyboardAccessoryButtonPosition = .overflow,
                menu: UIMenu? = nil,
                tapHandler: (() -> Void)? = nil) {
        guard let imageName = Self.imageNameMap[type],
              let image = UIImage(systemName: imageName) else {
            fatalError("[AccessoryKit] Error: Do not have corresponding image for button type \(type)")
        }
        self.init(
            identifier: identifier,
            title: Self.titleMap[type],
            image: image,
            tintColor: tintColor,
            position: position,
            menu: menu,
            tapHandler: tapHandler)
    }

}
