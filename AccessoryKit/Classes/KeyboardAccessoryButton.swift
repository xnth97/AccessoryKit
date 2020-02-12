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
    /// - Parameters:
    ///   - type: Pre-defined button type.
    ///   - tapHandler: The tap handler that will be invoked when tapping the button.
    public convenience init(type: ButtonType,
                tapHandler: @escaping () -> Void) {
        let imageNameMap: [ButtonType: String] = [
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
        let image = UIImage(named: imageNameMap[type]!, in: Bundle(for: KeyboardAccessoryButton.self), compatibleWith: nil)!
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
            backgroundColor = .systemGray5
        } else {
            backgroundColor = UIColor(white: 0.8, alpha: 1.0)
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
