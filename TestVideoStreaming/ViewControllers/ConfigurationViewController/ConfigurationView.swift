//
//  ConfigurationView.swift
//  TestVideoStreaming
//
//  Created by Pavel Bondar on 06.01.26.
//

import UIKit

final class ConfigurationView: UIView {
    let urlTextField = PaddedTextField()
    let keyTextField = PaddedTextField()
    let actionButton = UIButton(type: .system)
    let errorLabel = UILabel()
    
    func setupUI() {
        backgroundColor = .systemBackground
        
        urlTextField.placeholder = Localization.configuration_url_placeholder.value
        
        keyTextField.placeholder = Localization.configuration_key_placeholder.value
        keyTextField.isSecureTextEntry = true
        
        actionButton.setTitle(Localization.configuration_to_stream_title.value, for: .normal)
        actionButton.titleLabel?.font = .systemFont(ofSize: Constants.buttonFontSize, weight: .medium)
        actionButton.layer.cornerRadius = Constants.buttonCornerRadius
        actionButton.backgroundColor = .systemBlue
        actionButton.setTitleColor(.white, for: .normal)
        
        errorLabel.textColor = .systemRed
        errorLabel.font = .systemFont(ofSize: 12)
        errorLabel.numberOfLines = 0
        errorLabel.isHidden = true
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        let stackView = UIStackView(arrangedSubviews: [urlTextField, keyTextField, errorLabel, actionButton])
        stackView.axis = .vertical
        stackView.spacing = Constants.spacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.sideSpacing),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.sideSpacing),
            actionButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight)
        ])
    }
    
    func showError(urlError: Bool, keyError: Bool, message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
        
        if urlError {
            urlTextField.setBorderColor(.systemRed, width: 1.5)
        }
        
        if keyError {
            keyTextField.setBorderColor(.systemRed, width: 1.5)
        }
        
        shakeAnimation()
    }
}

// MARK: ConfigurationView + validation animation
extension ConfigurationView {
    func resetStyle(for textField: UITextField) {
        textField.layer.borderColor = UIColor.systemGray4.cgColor
        textField.layer.borderWidth = 1.0
    }
    
    func shakeAnimation() {
        let keyPath: String = "position"
        let animation = CABasicAnimation(keyPath: keyPath)
        animation.duration = 0.07
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: center.x - 2, y: center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: center.x + 2, y: center.y))
        layer.add(animation, forKey: keyPath)
    }
}

