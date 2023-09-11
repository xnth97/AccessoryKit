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

    private lazy var keyButtonGroups: [KeyboardAccessoryButtonGroup] = [
        [
            KeyboardAccessoryButton(type: .tab, position: .trailing),
        ],
        [
            KeyboardAccessoryButton(identifier: "undo", type: .undo, position: .leading) { [weak self] in
                self?.undo()
            },
            KeyboardAccessoryButton(identifier: "redo", type: .redo, position: .leading) { [weak self] in
                self?.redo()
            },
        ],
        [

            KeyboardAccessoryButton(type: .bold),
            KeyboardAccessoryButton(type: .italic),
            KeyboardAccessoryButton(type: .delete),
        ],
        [
            KeyboardAccessoryButton(type: .link, menu: createInsertMenu()),
            KeyboardAccessoryButton(type: .image),
            KeyboardAccessoryButton(title: "Esc"),
        ],
        [
            KeyboardAccessoryButton(type: .header),
            KeyboardAccessoryButton(type: .code),
            KeyboardAccessoryButton(type: .item),
            KeyboardAccessoryButton(type: .quote),
        ],
    ]
    private lazy var accessoryManager = KeyboardAccessoryManager(keyButtonGroups: keyButtonGroups, delegate: self)

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
        accessoryManager.setEnabled(textView.undoManager?.canUndo ?? false, for: "undo")
        accessoryManager.setEnabled(textView.undoManager?.canRedo ?? false, for: "redo")
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
