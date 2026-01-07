//
//  StreamView.swift
//  TestVideoStreaming
//
//  Created by Pavel Bondar on 06.01.26.
//

import UIKit
import HaishinKit

final class StreamView: UIView {
    
    // Video Preview Layer
    let hkView: MTHKView = {
        let view = MTHKView(frame: .zero)
        view.videoGravity = .resizeAspectFill
        return view
    }()
    
    // UI Components
    let statusBadge: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        return view
    }()
    
    let timerLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00:00"
        label.textColor = .white
        label.font = .monospacedDigitSystemFont(ofSize: 15, weight: .bold)
        return label
    }()
    
    let startButton: UIButton = {
        let button = CircularButton.create(systemName: Constants.IconsNames.play, backgroundColor: .systemIndigo)
        return button
    }()
    
    // Using the custom circular helper
    let muteButton = CircularButton.create(systemName: Constants.IconsNames.mic)
    let switchButton = CircularButton.create(systemName: Constants.IconsNames.switchCamera)

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = .black
        
        [hkView, statusBadge, startButton, muteButton, switchButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        statusBadge.addSubview(timerLabel)
        timerLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            statusBadge.centerXAnchor.constraint(equalTo: centerXAnchor),
            statusBadge.widthAnchor.constraint(equalToConstant: 120),
            statusBadge.heightAnchor.constraint(equalToConstant: 30),
            statusBadge.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            
            timerLabel.centerXAnchor.constraint(equalTo: statusBadge.centerXAnchor),
            timerLabel.centerYAnchor.constraint(equalTo: statusBadge.centerYAnchor),
            
            startButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -Constants.controlPadding),
            startButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            startButton.widthAnchor.constraint(equalToConstant: Constants.streamButtonSize),
            startButton.heightAnchor.constraint(equalToConstant: Constants.streamButtonSize),
            
            muteButton.centerYAnchor.constraint(equalTo: startButton.centerYAnchor),
            muteButton.trailingAnchor.constraint(equalTo: startButton.leadingAnchor, constant: -Constants.controlPadding),
            muteButton.widthAnchor.constraint(equalToConstant: Constants.controlButtonSize),
            muteButton.heightAnchor.constraint(equalToConstant: Constants.controlButtonSize),
            
            switchButton.centerYAnchor.constraint(equalTo: startButton.centerYAnchor),
            switchButton.leadingAnchor.constraint(equalTo: startButton.trailingAnchor, constant: Constants.controlPadding),
            switchButton.widthAnchor.constraint(equalToConstant: Constants.controlButtonSize),
            switchButton.heightAnchor.constraint(equalToConstant: Constants.controlButtonSize),
            
            hkView.topAnchor.constraint(equalTo: topAnchor),
            hkView.leadingAnchor.constraint(equalTo: leadingAnchor),
            hkView.trailingAnchor.constraint(equalTo: trailingAnchor),
            hkView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
