//
//  Storage.swift
//  TestVideoStreaming
//
//  Created by Pavel Bondar on 24.12.25.
//

import Foundation

protocol StreamingStorage {
    var urlString: String? { get set }
    var keyString: String? { get set }
}

private enum Keys: String {
    case url
    case key
}

final class UserDefaultsStorage: StreamingStorage {
    
    
    private let defaults: UserDefaults
    
    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }
    
    var urlString: String? {
        get { defaults.string(forKey: Keys.url.rawValue) }
        set { defaults.set(newValue, forKey: Keys.url.rawValue) }
    }
    
    var keyString: String? {
        get { defaults.string(forKey: Keys.key.rawValue) }
        set { defaults.set(newValue, forKey: Keys.key.rawValue) }
    }
}
