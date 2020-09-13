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
    
    /// The image that is shown on the button.
    public let image: UIImage
    
    /// The tap handler that will be invoked when tapping the button.
    public let tapHandler: () -> Void
    
    /// Initialize the view model of key button inside `KeyboardAccessoryView`.
    /// - Parameters:
    ///   - image: The image that is shown on the button.
    ///   - tapHandler: The tap handler that will be invoked when tapping the button.
    public init(image: UIImage,
                tapHandler: @escaping () -> Void) {
        self.image = image
        self.tapHandler = tapHandler
    }
    
    /// Initialize the view model of key button with a given button type.
    ///
    /// For pre-defined button types, on iOS 13+ the button will try to use SF Symbol
    /// for proper image, otherwise will use the bundled image from Google Material Icons.
    ///
    /// - Parameters:
    ///   - type: Pre-defined button type.
    ///   - tapHandler: The tap handler that will be invoked when tapping the button.
    public init(type: ButtonType,
                tapHandler: @escaping () -> Void) {
        let image = UIImage(systemName: Self.imageNameMap[type]!)!
        self.init(image: image, tapHandler: tapHandler)
    }
    
}
