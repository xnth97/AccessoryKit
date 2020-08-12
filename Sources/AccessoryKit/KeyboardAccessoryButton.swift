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
        let image = UIImage(systemName: Self.imageNameMap[type]!)!
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
        backgroundColor = .tertiarySystemGroupedBackground
        
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
