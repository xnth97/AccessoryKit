//
//  KeyboardAccessoryGroupView.swift
//  AccessoryKit
//
//  Created by Yubo Qin on 9/11/23.
//

import UIKit

class KeyboardAccessoryGroupView: UIView {

    private static let spacing: CGFloat = 2.0

    private let viewModels: KeyboardAccessoryButtonGroup
    private let viewSize: CGSize
    private let stackView = UIStackView()
    private let buttonViews: [KeyboardAccessoryButtonView]

    init(viewModels: KeyboardAccessoryButtonGroup,
         keyWidth: CGFloat,
         height: CGFloat,
         cornerRadius: CGFloat) {
        self.viewModels = viewModels
        self.viewSize = Self.calculateSize(
            viewModels: viewModels,
            keyWidth: keyWidth,
            keyHeight: height,
            spacing: Self.spacing)
        self.buttonViews = viewModels.map { viewModel in
            return KeyboardAccessoryButtonView(
                viewModel: viewModel,
                width: keyWidth,
                height: height,
                cornerRadius: cornerRadius,
                ignoreCornerRadius: true)
        }
        super.init(frame: CGRect(origin: .zero, size: viewSize))
        setupViews(
            keyWidth: keyWidth,
            keyHeight: height,
            cornerRadius: cornerRadius)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews(keyWidth: CGFloat,
                            keyHeight: CGFloat,
                            cornerRadius: CGFloat) {
        addSubview(stackView)

        stackView.axis = .horizontal
        stackView.spacing = Self.spacing

        for buttonView in buttonViews {
            stackView.addArrangedSubview(buttonView)
        }

        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])

        clipsToBounds = true
        layer.cornerRadius = cornerRadius
    }

    // MARK: - Overrides

    override var intrinsicContentSize: CGSize {
        viewSize
    }

    override var tintColor: UIColor! {
        get {
            super.tintColor
        }
        set {
            buttonViews.forEach { $0.tintColor = newValue }
            super.tintColor = newValue
        }
    }

    private static func calculateSize(viewModels: KeyboardAccessoryButtonGroup,
                                      keyWidth: CGFloat,
                                      keyHeight: CGFloat,
                                      spacing: CGFloat) -> CGSize {
        let width = keyWidth * CGFloat(viewModels.count) + spacing * CGFloat(viewModels.count - 1)
        return CGSize(width: width, height: keyHeight)
    }

}
