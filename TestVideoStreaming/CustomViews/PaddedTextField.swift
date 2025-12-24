//
//  PaddedTextField.swift
//  TestVideoStreaming
//
//  Created by Pavel Bondar on 23.12.25.
//

import UIKit

private let paddingValue: CGFloat = 12

final class PaddedTextField: UITextField {
    private let padding = UIEdgeInsets(top: paddingValue, left: paddingValue, bottom: paddingValue, right: paddingValue)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUI()
    }
    
    private func setupUI() {
        setupStyle()
        addDoneButtonOnKeyboard()
    }
    
    private func setupStyle() {
        backgroundColor = .systemBackground
        layer.cornerRadius = 8
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.systemGray4.cgColor
        borderStyle = .none
        autocorrectionType = .no
        spellCheckingType = .no
        autocapitalizationType = .none
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    func setBorderColor(_ color: UIColor, width: CGFloat = 1.0) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }
    
    @objc private func doneButtonAction() {
        self.resignFirstResponder()
    }
    
    private func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(
            title: Localization.done_button_title.value,
            style: .done,
            target: self,
            action: #selector(self.doneButtonAction)
        )
        
        doneToolbar.items = [flexSpace, done]
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
}
