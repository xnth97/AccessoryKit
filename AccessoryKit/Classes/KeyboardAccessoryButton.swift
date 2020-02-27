//
//  KeyboardAccessoryButton.swift
//  AccessoryKit
//
//  Created by Yubo Qin on 2/11/20.
//

import UIKit

/// View model class that represents a key button inside `KeyboardAccessoryView`.
public class KeyboardAccessoryButton {
    
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
        .tab: "editor_tab",
        .undo: "editor_undo",
        .redo: "editor_redo",
        .header: "editor_header",
        .bold: "editor_bold",
        .italic: "editor_italic",
        .code: "editor_code",
        .delete: "editor_delete",
        .item: "editor_item",
        .quote: "editor_quote",
        .link: "editor_link",
        .image: "editor_image",
    ]
    
    private static let sfSymbolNameMap: [ButtonType: String] = [
        .tab: "increase.indent",
        .undo: "arrow.uturn.left",
        .redo: "arrow.uturn.right",
        .bold: "bold",
        .italic: "italic",
        .code: "chevron.left.slash.chevron.right",
        .delete: "strikethrough",
        .item: "list.bullet",
        .quote: "text.quote",
        .link: "link",
        .image: "photo",
    ]
    
    public let image: UIImage
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
    public convenience init(type: ButtonType,
                            tapHandler: @escaping () -> Void) {
        var image: UIImage
        if #available(iOS 13.0, *), KeyboardAccessoryButton.sfSymbolNameMap[type] != nil {
            image = UIImage(systemName: KeyboardAccessoryButton.sfSymbolNameMap[type]!)!
        } else {
            image = UIImage(named: KeyboardAccessoryButton.imageNameMap[type]!,
                            in: Bundle(for: KeyboardAccessoryButton.self),
                            compatibleWith: nil)!
        }
        self.init(image: image, tapHandler: tapHandler)
    }
    
}

/// Real `UIButton` class is constructed from the view model `KeyboardAccessoryButton`.
class KeyboardAccessoryButtonView: UIButton {
    
    private let viewModel: KeyboardAccessoryButton
    
    init(viewModel: KeyboardAccessoryButton,
         width: CGFloat,
         height: CGFloat,
         cornerRadius: CGFloat) {
        self.viewModel = viewModel
        super.init(frame: CGRect(x: 0, y: 0, width: width, height: height))
        
        setImage(viewModel.image, for: .normal)
        if #available(iOS 13.0, *) {
            backgroundColor = .tertiarySystemGroupedBackground
        } else {
            backgroundColor = UIColor(red:0.94, green:0.94, blue:0.96, alpha:1.0)
        }
        
        clipsToBounds = true
        layer.cornerRadius = cornerRadius
        translatesAutoresizingMaskIntoConstraints = false
        addTarget(self, action: #selector(tapHandlerAction), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tapHandlerAction() {
        viewModel.tapHandler()
    }
    
}
