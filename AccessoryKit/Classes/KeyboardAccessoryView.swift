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
public class KeyboardAccessoryView: UIView {
    
    // Constants
    public static let defaultKeyWidth: CGFloat = 60.0
    public static let defaultKeyHeight: CGFloat = 40.0
    public static let defaultKeyCornerRadius: CGFloat = 8.0
    public static let defaultKeyMargin: CGFloat = 8.0
    
    private let keysScrollView = UIScrollView(frame: .zero)
    private let keysStackView = UIStackView(frame: .zero)
    private let backgroundView: UIVisualEffectView = {
        let effect = UIBlurEffect(style: .regular)
        let v = UIVisualEffectView(effect: effect)
        return v
    }()
    
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
    ///   - keyWidth: The width of each key inside `KeyboardAccessoryView`.
    ///   - keyHeight: The height of each key inside `KeyboardAccessoryView`.
    ///   - keyCornerRadius: The corner radius of each key inside `KeyboardAccessoryView`.
    ///   - keyMargin: The margin between keys inside `KeyboardAccessoryView`.
    ///   - keyButtons: An array of `KeyboardAccessoryButton` model to construct the keys.
    ///   - showDismissKeyboardKey: If show the dismiss keyboard key on the right of scrollable area.
    ///   - delegate: Delegate object that implements `KeyboardAccessoryViewDelegate`.
    public init(frame: CGRect = .zero,
         keyWidth: CGFloat = KeyboardAccessoryView.defaultKeyWidth,
         keyHeight: CGFloat = KeyboardAccessoryView.defaultKeyHeight,
         keyCornerRadius: CGFloat = KeyboardAccessoryView.defaultKeyCornerRadius,
         keyMargin: CGFloat = KeyboardAccessoryView.defaultKeyMargin,
         keyButtons: [KeyboardAccessoryButton] = [],
         showDismissKeyboardKey: Bool = true,
         delegate: KeyboardAccessoryViewDelegate?) {
        self.keyWidth = keyWidth
        self.keyHeight = keyHeight
        self.keyCornerRadius = keyCornerRadius
        self.keyMargin = keyMargin
        self.keyButtonViews = keyButtons.map { buttonModel in
            return KeyboardAccessoryButtonView(viewModel: buttonModel, width: keyWidth, height: keyHeight, cornerRadius: keyCornerRadius)
        }
        self.showDismissKeyboardKey = showDismissKeyboardKey
        self.delegate = delegate
        
        let newFrame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: 2 * keyMargin + keyHeight)
        super.init(frame: newFrame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        var constraints: [NSLayoutConstraint] = []
        
        addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        constraints.append(contentsOf: [
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        addSubview(keysScrollView)
        keysScrollView.translatesAutoresizingMaskIntoConstraints = false
        keysScrollView.alwaysBounceHorizontal = true
        constraints.append(contentsOf: [
            keysScrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            keysScrollView.topAnchor.constraint(equalTo: topAnchor),
            keysScrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        if let image = UIImage(named: "dismiss_keyboard", in: Bundle(for: KeyboardAccessoryView.self), compatibleWith: nil), showDismissKeyboardKey {
            let dismissKey = KeyboardAccessoryButton(image: image, tapHandler: { [weak self] in
                self?.dismissKeyboardKeyTapped()
            })
            let dismissKeyView = KeyboardAccessoryButtonView(viewModel: dismissKey, width: keyWidth, height: keyHeight, cornerRadius: keyCornerRadius)
            addSubview(dismissKeyView)
            constraints.append(contentsOf: [
                dismissKeyView.widthAnchor.constraint(equalToConstant: keyWidth),
                dismissKeyView.heightAnchor.constraint(equalToConstant: keyHeight),
                dismissKeyView.centerYAnchor.constraint(equalTo: centerYAnchor),
                keysScrollView.trailingAnchor.constraint(equalTo: dismissKeyView.leadingAnchor, constant: -keyMargin),
            ])
            if #available(iOS 11.0, *) {
                constraints.append(dismissKeyView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -keyMargin))
            }
        } else {
            constraints.append(keysScrollView.trailingAnchor.constraint(equalTo: trailingAnchor))
        }
        
        keysScrollView.addSubview(keysStackView)
        keysStackView.translatesAutoresizingMaskIntoConstraints = false
        keysStackView.axis = .horizontal
        keysStackView.spacing = keyMargin
        constraints.append(contentsOf: [
            keysStackView.leadingAnchor.constraint(equalTo: keysScrollView.leadingAnchor, constant: keyMargin),
            keysStackView.heightAnchor.constraint(equalTo: keysScrollView.heightAnchor, constant: -2 * keyMargin),
            keysStackView.centerYAnchor.constraint(equalTo: keysScrollView.centerYAnchor),
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
        NSLayoutConstraint.activate([
            keyView.widthAnchor.constraint(equalToConstant: keyWidth),
            keyView.heightAnchor.constraint(equalToConstant: keyHeight),
            keyView.centerYAnchor.constraint(equalTo: keysStackView.centerYAnchor),
        ])
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
    
}
