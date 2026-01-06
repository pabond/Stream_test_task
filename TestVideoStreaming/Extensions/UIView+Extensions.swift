//
//  UIView+Extensions.swift
//  TestVideoStreaming
//
//  Created by Pavel Bondar on 25.12.25.
//

import UIKit

extension UIView {

    var safeAreaBottom: CGFloat {
        if let window = UIApplication.shared.keyWindowInConnectedScenes {
            return window.safeAreaInsets.bottom
        }
        
        return 0
    }

    var safeAreaTop: CGFloat {
        if let window = UIApplication.shared.keyWindowInConnectedScenes {
            return window.safeAreaInsets.top
        }
        
        return 0
    }
}
