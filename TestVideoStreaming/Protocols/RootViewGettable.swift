//
//  RootViewGettable.swift
//  TestVideoStreaming
//
//  Created by Pavel Bondar on 06.01.26.
//

import Foundation
import UIKit

public protocol RootViewGettable {
    
    associatedtype RootViewType: UIView
    
    var rootView: RootViewType? { get }
}

public extension RootViewGettable where Self: UIViewController {
    
    /**
     Cast viewIfLoaded property to RootViewType type and return result.
     This implementation use viewIfLoaded propery of UIViewController instance.
     */
    
    var rootView: RootViewType? {
        return self.viewIfLoaded.flatMap({$0 as? RootViewType})
    }
}
