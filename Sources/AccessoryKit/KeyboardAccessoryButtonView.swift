//
//  KeyboardAccessoryButton.swift
//  AccessoryKit
//
//  Created by Yubo Qin on 2/11/20.
//

import UIKit

/// Internal subview class that is represented by view model `KeyboardAccessoryButton`.
class KeyboardAccessoryButtonView: UIView {

    private let button = UIButton(type: .custom)
    private let viewModel: KeyboardAccessoryButton
    private let viewSize: CGSize

    init(viewModel: KeyboardAccessoryButton,
         width: CGFloat,
         height: CGFloat,
         cornerRadius: CGFloat) {
        self.viewModel = viewModel
        viewSize = CGSize(width: width, height: height)
        super.init(frame: CGRect(x: 0, y: 0, width: width, height: height))

        addSubview(button)

        button.setImage(viewModel.image, for: .normal)
        button.setTitle(viewModel.title, for: .normal)

        button.tintColor = viewModel.tintColor
        button.setTitleColor(viewModel.tintColor, for: .normal)

        if let font = viewModel.font {
            button.titleLabel?.font = font
        }

        button.backgroundColor = .tertiarySystemGroupedBackground

        button.clipsToBounds = true
        button.layer.cornerRadius = cornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false
        translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: topAnchor),
            button.bottomAnchor.constraint(equalTo: bottomAnchor),
            button.leadingAnchor.constraint(equalTo: leadingAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])

        if #available(iOS 14.0, *) {
            if let menu = viewModel.menu {
                button.menu = menu
                button.showsMenuAsPrimaryAction = true
                return
            }
        }

        if viewModel.tapHandler != nil {
            button.addTarget(self, action: #selector(tapHandlerAction), for: .touchUpInside)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func tapHandlerAction() {
        viewModel.tapHandler?()
    }

    // MARK: - APIs

    override var intrinsicContentSize: CGSize {
        return viewSize
    }

    override var tintColor: UIColor! {
        didSet {
            button.tintColor = tintColor
            button.setTitleColor(tintColor, for: .normal)
        }
    }

    var isEnabled: Bool {
        set {
            button.isEnabled = newValue
        }
        get {
            button.isEnabled
        }
    }

}
