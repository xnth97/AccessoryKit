//
//  KeyboardAccessoryView.swift
//  AccessoryKit
//
//  Created by Yubo Qin on 2/11/20.
//

import UIKit

/// Delegate for `KeyboardAccessoryView`.
@objc public protocol KeyboardAccessoryViewDelegate: class {
    
    /// This function is called when `KeyboardAccessoryView` has `showDismissKeyboardKey` and the dismiss keyboard
    /// key is tapped.
    @objc optional func dismissKeyboardButtonTapped()
}

/// The `UIView` class that works as the `inputAccessoryView`, usually looks like a toolbar on top of the screen keyboard.
public class KeyboardAccessoryView: UIInputView {
    
    // Constants
    public static let defaultKeyWidth: CGFloat = 60.0
    public static let defaultKeyHeight: CGFloat = 40.0
    public static let defaultKeyCornerRadius: CGFloat = 8.0
    public static let defaultKeyMargin: CGFloat = 8.0
    
    private let container = UIView()
    private let keysScrollView = UIScrollView()
    private let keysStackView = UIStackView()
    
    private let keyMargin: CGFloat
    private let keyWidth: CGFloat
    private let keyHeight: CGFloat
    private let keyCornerRadius: CGFloat
    private let keyButtonViews: [KeyboardAccessoryButtonView]
    private let showDismissKeyboardKey: Bool
    
    public var accessoryViewHeight: CGFloat {
        return 2 * keyMargin + keyHeight
    }
    
    private weak var delegate: KeyboardAccessoryViewDelegate?
    
    /// Initializer of `KeyboardAccessoryView`
    /// - Parameters:
    ///   - frame: The frame rectangle, which describes the view’s location and size in its superview’s coordinate system.
    ///   - inputViewStyle: The style to use when altering the appearance of the view and its subviews.
    ///   - keyWidth: The width of each key inside `KeyboardAccessoryView`.
    ///   - keyHeight: The height of each key inside `KeyboardAccessoryView`.
    ///   - keyCornerRadius: The corner radius of each key inside `KeyboardAccessoryView`.
    ///   - keyMargin: The margin between keys inside `KeyboardAccessoryView`.
    ///   - keyButtons: An array of `KeyboardAccessoryButton` model to construct the keys.
    ///   - showDismissKeyboardKey: If show the dismiss keyboard key on the right of scrollable area.
    ///   - delegate: Delegate object that implements `KeyboardAccessoryViewDelegate`.
    public init(frame: CGRect = .zero,
                inputViewStyle: UIInputView.Style = .keyboard,
                keyWidth: CGFloat = KeyboardAccessoryView.defaultKeyWidth,
                keyHeight: CGFloat = KeyboardAccessoryView.defaultKeyHeight,
                keyCornerRadius: CGFloat = KeyboardAccessoryView.defaultKeyCornerRadius,
                keyMargin: CGFloat = KeyboardAccessoryView.defaultKeyMargin,
                keyButtons: [KeyboardAccessoryButton] = [],
                showDismissKeyboardKey: Bool = true,
                delegate: KeyboardAccessoryViewDelegate? = nil) {
        self.keyWidth = keyWidth
        self.keyHeight = keyHeight
        self.keyCornerRadius = keyCornerRadius
        self.keyMargin = keyMargin
        self.keyButtonViews = keyButtons.map { buttonModel in
            return KeyboardAccessoryButtonView(viewModel: buttonModel,
                                               width: keyWidth,
                                               height: keyHeight,
                                               cornerRadius: keyCornerRadius)
        }
        self.showDismissKeyboardKey = showDismissKeyboardKey
        self.delegate = delegate
        
        let newFrame = CGRect(x: frame.origin.x,
                              y: frame.origin.y,
                              width: frame.size.width,
                              height: 2 * keyMargin + keyHeight)
        super.init(frame: newFrame, inputViewStyle: inputViewStyle)
        setupViews()
        
        autoresizingMask = .flexibleHeight
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        var constraints: [NSLayoutConstraint] = []
        
        addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false
        constraints.append(contentsOf: [
            container.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            container.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            container.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            container.heightAnchor.constraint(equalToConstant: accessoryViewHeight),
        ])
        
        container.addSubview(keysScrollView)
        keysScrollView.translatesAutoresizingMaskIntoConstraints = false
        keysScrollView.alwaysBounceHorizontal = true
        constraints.append(contentsOf: [
            keysScrollView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            keysScrollView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            keysScrollView.heightAnchor.constraint(equalToConstant: keyHeight),
        ])
        
        let keyboardDismissImage = UIImage(systemName: "keyboard.chevron.compact.down")
        if let image = keyboardDismissImage, showDismissKeyboardKey {
            let dismissKey = KeyboardAccessoryButton(image: image) { [weak self] in
                self?.dismissKeyboardKeyTapped()
            }
            let dismissKeyView = KeyboardAccessoryButtonView(viewModel: dismissKey,
                                                             width: keyWidth,
                                                             height: keyHeight,
                                                             cornerRadius: keyCornerRadius)
            container.addSubview(dismissKeyView)
            constraints.append(contentsOf: [
                dismissKeyView.widthAnchor.constraint(equalToConstant: keyWidth),
                dismissKeyView.heightAnchor.constraint(equalToConstant: keyHeight),
                dismissKeyView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
                dismissKeyView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -keyMargin),
                keysScrollView.trailingAnchor.constraint(equalTo: dismissKeyView.leadingAnchor, constant: -keyMargin),
            ])
        } else {
            constraints.append(keysScrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor))
        }
        
        keysScrollView.addSubview(keysStackView)
        keysStackView.translatesAutoresizingMaskIntoConstraints = false
        keysStackView.axis = .horizontal
        keysStackView.spacing = keyMargin
        constraints.append(contentsOf: [
            keysStackView.leadingAnchor.constraint(equalTo: keysScrollView.leadingAnchor, constant: keyMargin),
            keysStackView.centerYAnchor.constraint(equalTo: keysScrollView.centerYAnchor),
            keysStackView.heightAnchor.constraint(equalToConstant: keyHeight),
        ])
        
        for buttonViewItem in keyButtonViews {
            addAccessoryKey(keyView: buttonViewItem)
        }
        
        NSLayoutConstraint.activate(constraints)
        
        keysStackView.layoutIfNeeded()
        let stackViewSize = keysStackView.frame.size
        keysScrollView.contentSize = CGSize(width: stackViewSize.width + keyMargin, height: stackViewSize.height)
        keysScrollView.showsHorizontalScrollIndicator = false
        keysScrollView.showsVerticalScrollIndicator = false
    }
    
    private func addAccessoryKey(keyView: UIView) {
        keysStackView.addArrangedSubview(keyView)
    }
    
    private func dismissKeyboardKeyTapped() {
        delegate?.dismissKeyboardButtonTapped?()
    }
    
    // MARK: - APIs
    
    /// Set `isEnabled` value on the key of a given index.
    /// - Parameters:
    ///   - enabled: Boolean value indicating whether the key is enabled.
    ///   - index: Index of key in `KeyboardAccessoryView`.
    public func setEnabled(_ enabled: Bool, at index: Int) {
        guard index >= 0 && index < keyButtonViews.count else {
            return
        }
        keyButtonViews[index].isEnabled = enabled
    }
    
    /// Set `tintColor` value on the key of a given index.
    /// - Parameters:
    ///   - tintColor: Tint color to be set.
    ///   - index: Index of key in `KeyboardAccessoryView`.
    public func setTintColor(_ tintColor: UIColor, at index: Int) {
        guard index >= 0 && index < keyButtonViews.count else {
            return
        }
        keyButtonViews[index].tintColor = tintColor
    }
    
    public override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: accessoryViewHeight)
    }
    
}
