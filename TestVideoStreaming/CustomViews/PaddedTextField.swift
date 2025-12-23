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
        setupStyle()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupStyle()
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
}
