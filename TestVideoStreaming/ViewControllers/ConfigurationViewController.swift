//
//  ConfigurationViewController.swift
//  TestVideoStreaming
//
//  Created by Pavel Bondar on 21.12.25.
//

import UIKit

class ConfigurationViewController: UIViewController {
    
    private let urlTextField = PaddedTextField()
    private let keyTextField = PaddedTextField()
    private let actionButton = UIButton(type: .system)
    private let errorLabel = UILabel()
    
    private var storage: StreamingStorage
    
    init(storage: StreamingStorage = UserDefaultsStorage()) {
        self.storage = storage
        super.init(nibName: nil, bundle: nil)
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    // MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupConstraints()
        fillFromStorage()
    }
    
    // MARK: UISetup
    /// Add needed subviewis
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = Localization.configuration_title.value
        
        urlTextField.placeholder = Localization.configuration_url_placeholder.value
        
        keyTextField.placeholder = Localization.configuration_key_placeholder.value
        keyTextField.isSecureTextEntry = true
        
        actionButton.setTitle(Localization.configuration_to_stream_title.value, for: .normal)
        actionButton.titleLabel?.font = .systemFont(ofSize: Constants.buttonFontSize, weight: .medium)
        actionButton.layer.cornerRadius = Constants.buttonCornerRadius
        actionButton.backgroundColor = .systemBlue
        actionButton.setTitleColor(.white, for: .normal)
        actionButton.addTarget(self, action: #selector(didTapContinue), for: .touchUpInside)
        
        errorLabel.textColor = .systemRed
        errorLabel.font = .systemFont(ofSize: 12)
        errorLabel.numberOfLines = 0
        errorLabel.isHidden = true
    }
    
    private func setupConstraints() {
        let stackView = UIStackView(arrangedSubviews: [urlTextField, keyTextField, errorLabel, actionButton])
        stackView.axis = .vertical
        stackView.spacing = Constants.spacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.sideSpacing),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.sideSpacing),
            actionButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight)
        ])
    }
    
    @objc private func didTapContinue() {
        let url = urlTextField.text ?? ""
        let key = keyTextField.text ?? ""
        
        resetStyle(for: urlTextField)
        resetStyle(for: keyTextField)
        errorLabel.text = nil
        
        var urlError = false
        var keyError = false
        var message = ""
        
        if url.isEmpty {
            urlError = true
            message = Localization.configuration_url_empty_error.value
        }
        if key.isEmpty {
            keyError = true
            message = (message.isEmpty)
                    ? Localization.configuration_key_empty_error.value
                    : Localization.configuration_key_empty_error.value
        }
        
        if !urlError && !url.isValidStreamingUrl {
            urlError = true
            message = Localization.configuration_incorrect_url_format_error.value
        }
        
        if urlError || keyError {
            showError(urlError: urlError, keyError: keyError, message: message)
        } else {
            storage.urlString = url
            storage.keyString = key
            proceedToStream()
        }
    }
    
    /// move to StreamViewController
    private func proceedToStream() {
        let streamViewController = StreamViewController(storage: storage)
        navigationController?.pushViewController(streamViewController, animated: true)
    }
    
    private func fillFromStorage() {
        urlTextField.text = storage.urlString
        keyTextField.text = storage.keyString
    }
    
    private func showError(urlError: Bool, keyError: Bool, message: String) {
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

// MARK: ConfigurationViewController + validation animation
private extension ConfigurationViewController {
    private func resetStyle(for textField: UITextField) {
        textField.layer.borderColor = UIColor.systemGray4.cgColor
        textField.layer.borderWidth = 1.0
    }
    
    private func shakeAnimation() {
        let keyPath: String = "position"
        let animation = CABasicAnimation(keyPath: keyPath)
        animation.duration = 0.07
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: view.center.x - 2, y: view.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: view.center.x + 2, y: view.center.y))
        view.layer.add(animation, forKey: keyPath)
    }
}
