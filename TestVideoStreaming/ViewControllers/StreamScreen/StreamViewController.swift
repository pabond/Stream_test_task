//
//  StreamViewController.swift
//  TestVideoStreaming
//
//  Created by Pavel Bondar on 25.12.25.
//

import UIKit

final class StreamViewController: UIViewController, RootViewGettable {
    typealias RootViewType = StreamView
    private let viewModel: StreamViewModel
    
    init(storage: StreamingStorage) {
        self.viewModel = StreamViewModel(storage: storage)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func loadView() {
        super.loadView()
        
        view = StreamView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInteractionBindings()
        bindViewModel()
        
        if let rootView {
            // Connect view to the mixer once UI is loaded
            Task { @MainActor in
                viewModel.connect(to: rootView.hkView)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIApplication.shared.isIdleTimerDisabled = false
        viewModel.stopRunning()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        rootView.map {
            $0.statusBadge.layer.cornerRadius = $0.statusBadge.frame.height / 2
        }
    }
    
    // MARK: Bind ViewModel callbacks to UI updates
    private func bindViewModel() {
        viewModel.onTimerUpdate = { [weak self] time in
            self?.rootView?.timerLabel.text = time
        }
        
        viewModel.onMuteUpdate = { [weak self] isMuted in
            let icon = isMuted ? Constants.IconsNames.mute : Constants.IconsNames.mic
            self?.rootView?.muteButton.setImage(UIImage(systemName: icon), for: .normal)
        }
        
        viewModel.onStreamingStatusUpdate = { [weak self] status in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch status {
                case .online:
                    self.rootView?.statusBadge.backgroundColor = .systemRed
                    self.rootView?.startButton.setImage(UIImage(systemName: Constants.IconsNames.stop), for: .normal)
                    self.rootView?.startButton.backgroundColor = .systemRed
                    self.rootView?.startButton.isEnabled = true
                    
                case .offline:
                    self.rootView?.statusBadge.backgroundColor = .systemGray
                    self.rootView?.startButton.setImage(UIImage(systemName: Constants.IconsNames.play), for: .normal)
                    self.rootView?.startButton.backgroundColor = .systemIndigo
                    self.rootView?.startButton.isEnabled = true
                    self.rootView?.timerLabel.text = "00:00:00"
                    
                case .connecting:
                    self.rootView?.statusBadge.backgroundColor = .systemOrange
                    self.rootView?.startButton.backgroundColor = .systemOrange
                    self.rootView?.startButton.setImage(UIImage(systemName: Constants.IconsNames.connecting), for: .normal)
                    self.rootView?.startButton.isEnabled = false
                    
                case .reconnecting:
                    self.rootView?.statusBadge.backgroundColor = .systemYellow
                    self.rootView?.startButton.backgroundColor = .systemYellow
                    self.rootView?.startButton.setImage(UIImage(systemName: Constants.IconsNames.connecting), for: .normal)
                    self.rootView?.startButton.isEnabled = true
                    
                case .error:
                    self.rootView?.statusBadge.backgroundColor = .black
                    self.rootView?.startButton.backgroundColor = .darkGray
                    self.rootView?.startButton.setImage(UIImage(systemName: Constants.IconsNames.error), for: .normal)
                    self.rootView?.startButton.isEnabled = true
                }
            }
        }
    }
    
    private func setupInteractionBindings() {
        rootView?.startButton.addTarget(self, action: #selector(didTapStart), for: .touchUpInside)
        rootView?.muteButton.addTarget(self, action: #selector(didTapMute), for: .touchUpInside)
        rootView?.switchButton.addTarget(self, action: #selector(didTapSwitch), for: .touchUpInside)
    }
    
    // MARK: User interactions
    @objc private func didTapStart() { viewModel.toggleStream() }
    @objc private func didTapMute() { viewModel.toggleMute() }
    @objc private func didTapSwitch() { viewModel.switchCamera() }
}
