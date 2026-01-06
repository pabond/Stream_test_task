//
//  UIApplication+Extensions.swift
//  TestVideoStreaming
//
//  Created by Pavel Bondar on 25.12.25.
//

import UIKit

extension UIApplication {
    var keyWindowInConnectedScenes: UIWindow? {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        
        return windowScene?.windows.first
    }
}
