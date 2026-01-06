//
//  CircularButton.swift
//  TestVideoStreaming
//
//  Created by Pavel Bondar on 06.01.26.
//

import UIKit

final class CircularButton: UIButton {
    
    static func create(systemName: String, backgroundColor: UIColor = .black.withAlphaComponent(0.4), tint: UIColor = .white) -> UIButton {
        let button = CircularButton(type: .system)
        button.setImage(UIImage(systemName: systemName), for: .normal)
        button.tintColor = tint
        button.backgroundColor = backgroundColor
        button.clipsToBounds = true
        
        return button
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = frame.height / 2
    }
}

