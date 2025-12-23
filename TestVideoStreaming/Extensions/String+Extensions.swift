//
//  String+Extensions.swift
//  TestVideoStreaming
//
//  Created by Pavel Bondar on 23.12.25.
//

import Foundation

extension String {
    
    func localized() -> String {
        NSLocalizedString(self, comment: "")
    }
    
    var isValidStreamingUrl: Bool {
        let rtmpRegex = #"^(rtmps?://)([a-zA-Z0-9.-]+\.[a-zA-Z]{2,})(:[0-9]+)?(/[a-zA-Z0-9._/-]*)?$"#
        
        let predicate = NSPredicate(format: "SELF MATCHES %@", rtmpRegex)
        return predicate.evaluate(with: self)
    }
}
