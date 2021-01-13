//
//  KeyboardAccessoryButton.swift
//  AccessoryKit
//
//  Created by Yubo Qin on 2/11/20.
//

import UIKit

/// Real `UIButton` class is constructed from the view model `KeyboardAccessoryButton`.
class KeyboardAccessoryButtonView: UIButton {
    
    private let viewModel: KeyboardAccessoryButton
    private let viewSize: CGSize
    
    init(viewModel: KeyboardAccessoryButton,
         width: CGFloat,
         height: CGFloat,
         cornerRadius: CGFloat) {
        self.viewModel = viewModel
        viewSize = CGSize(width: width, height: height)
        super.init(frame: CGRect(x: 0, y: 0, width: width, height: height))
        
        setImage(viewModel.image, for: .normal)
        backgroundColor = .tertiarySystemGroupedBackground
        
        clipsToBounds = true
        layer.cornerRadius = cornerRadius
        translatesAutoresizingMaskIntoConstraints = false

        if #available(iOS 14.0, *) {
            if let menu = viewModel.menu {
                self.menu = menu
                showsMenuAsPrimaryAction = true
                return
            }
        }

        if viewModel.tapHandler != nil {
            addTarget(self, action: #selector(tapHandlerAction), for: .touchUpInside)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tapHandlerAction() {
        viewModel.tapHandler?()
    }
    
    override var intrinsicContentSize: CGSize {
        return viewSize
    }
    
}
