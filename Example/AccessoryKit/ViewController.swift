//
//  ViewController.swift
//  AccessoryKit
//
//  Created by Yubo Qin on 02/11/2020.
//  Copyright (c) 2020 Yubo Qin. All rights reserved.
//

import UIKit
import AccessoryKit

class ViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!

    private lazy var keyButtons: [KeyboardAccessoryButton] = [
        KeyboardAccessoryButton(type: .tab, position: .trailing),
        KeyboardAccessoryButton(type: .undo, position: .leading) { [weak self] in
            self?.undo()
        },
        KeyboardAccessoryButton(type: .redo, position: .leading) { [weak self] in
            self?.redo()
        },
        KeyboardAccessoryButton(type: .header),
        KeyboardAccessoryButton(type: .bold),
        KeyboardAccessoryButton(type: .italic),
        KeyboardAccessoryButton(type: .code),
        KeyboardAccessoryButton(type: .delete),
        KeyboardAccessoryButton(type: .item),
        KeyboardAccessoryButton(type: .quote),
        KeyboardAccessoryButton(type: .link, menu: createInsertMenu()),
        KeyboardAccessoryButton(type: .image),
        KeyboardAccessoryButton(title: "Esc", image: UIImage(systemName: "escape")),
    ]
    private lazy var accessoryManager = KeyboardAccessoryManager(keyButtons: keyButtons, delegate: self)

    override func viewDidLoad() {
        super.viewDidLoad()

        textView.delegate = self
        textView.alwaysBounceVertical = true
        accessoryManager.configure(textView: textView)
        updateAccessoryViewButtonEnabled()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func undo() {
        textView.undoManager?.undo()
        updateAccessoryViewButtonEnabled()
    }
    
    private func redo() {
        textView.undoManager?.redo()
        updateAccessoryViewButtonEnabled()
    }
    
    private func updateAccessoryViewButtonEnabled() {
//        accessoryView.setEnabled(textView.undoManager?.canUndo ?? false, at: 1)
//        accessoryView.setEnabled(textView.undoManager?.canRedo ?? false, at: 2)
    }

    private func createInsertMenu() -> UIMenu {
        return UIMenu(
            title: "",
            image: nil,
            identifier: nil,
            options: .displayInline,
            children: [
                UIAction(
                    title: "Insert link",
                    image: UIImage(systemName: "link"),
                    handler: { _ in }),
                UIAction(
                    title: "Insert image",
                    image: UIImage(systemName: "photo"),
                    handler: { _ in }),
                UIAction(
                    title: "Insert math formula",
                    image: UIImage(systemName: "function"),
                    handler: { _ in }),
            ])
    }

}

extension ViewController: KeyboardAccessoryViewDelegate {
    
    func dismissKeyboardButtonTapped() {
        textView.resignFirstResponder()
    }
    
}

extension ViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        updateAccessoryViewButtonEnabled()
    }
    
}
