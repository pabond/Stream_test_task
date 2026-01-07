//
//  ConfigurationViewController.swift
//  TestVideoStreaming
//
//  Created by Pavel Bondar on 21.12.25.
//

import UIKit

class ConfigurationViewController: UIViewController, RootViewGettable {
    typealias RootViewType = ConfigurationView
    private var storage: StreamingStorage
    
    init(storage: StreamingStorage = UserDefaultsStorage()) {
        self.storage = storage
        super.init(nibName: nil, bundle: nil)
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    // MARK: View life cycle
    override func loadView() {
        super.loadView()
        
        view = ConfigurationView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        fillFromStorage()
    }
    
    // MARK: UISetup
    /// Add needed subviewis
    private func setupUI() {
        title = Localization.configuration_title.value
        rootView?.setupUI()
        rootView?.actionButton.addTarget(self, action: #selector(didTapContinue), for: .touchUpInside)
    }
    
    @objc func didTapContinue() {
        let url = rootView?.urlTextField.text ?? ""
        let key = rootView?.keyTextField.text ?? ""
        
        rootView.map {
            $0.resetStyle(for: $0.urlTextField)
            $0.resetStyle(for: $0.keyTextField)
        }
        
        rootView?.errorLabel.text = nil
        
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
            rootView?.showError(urlError: urlError, keyError: keyError, message: message)
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
        rootView?.urlTextField.text = storage.urlString
        rootView?.keyTextField.text = storage.keyString
    }
}
