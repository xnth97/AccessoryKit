//
//  KeyboardAccessoryButton.swift
//  AccessoryKit
//
//  Created by Yubo Qin on 9/13/20.
//

import UIKit

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

    // MARK: - Properties

    /// The image that is shown on the button.
    public let image: UIImage?

    /// The title that is shown on the button.
    public let title: String?

    /// The font of title label of button.
    public let font: UIFont?

    /// The tint color of button. Please note that this will be overriden if `KeyboardAccessoryView`
    /// sets tint color.
    public let tintColor: UIColor

    /// The tap handler that will be invoked when tapping the button.
    public let tapHandler: (() -> Void)?

    /// The menu that will be shown once button is tapped.
    public let menu: UIMenu?

    // MARK: - Initializers

    /// Initialize the view model of key button inside `KeyboardAccessoryView`.
    /// - Parameters:
    ///   - title: The title that is shown on the button.
    ///   - font: The font of title label of button.
    ///   - image: The image that is shown on the button.
    ///   - tintColor: The tint color of button.
    ///   - menu: The menu that will be shown once button is tapped. Only available for iOS 14+.
    ///   - tapHandler: The tap handler that will be invoked when tapping the button.
    public init(title: String? = nil,
                font: UIFont? = nil,
                image: UIImage? = nil,
                tintColor: UIColor = .systemBlue,
                menu: UIMenu? = nil,
                tapHandler: (() -> Void)? = nil) {
        if title == nil && image == nil {
            fatalError("[AccessoryKit] Error: Must provide a title or an image for button.")
        }
        self.title = title
        self.font = font
        self.image = image
        self.tapHandler = tapHandler
        self.menu = menu
        self.tintColor = tintColor
    }

    /// Initialize the view model of key button with a given button type.
    /// - Parameters:
    ///   - type: Pre-defined button type.
    ///   - tapHandler: The tap handler that will be invoked when tapping the button.
    ///   - menu: The menu that will be shown once button is tapped. Only available for iOS 14+.
    public init(type: ButtonType,
                tintColor: UIColor = .systemBlue,
                menu: UIMenu? = nil,
                tapHandler: (() -> Void)? = nil) {
        guard let imageName = Self.imageNameMap[type],
              let image = UIImage(systemName: imageName) else {
            fatalError("[AccessoryKit] Error: Do not have corresponding image for button type \(type)")
        }
        self.init(image: image, tintColor: tintColor, menu: menu, tapHandler: tapHandler)
    }

}
