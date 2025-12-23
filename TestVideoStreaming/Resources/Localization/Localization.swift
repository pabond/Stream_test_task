//
//  LocalizationStrings.swift
//  TestVideoStreaming
//
//  Created by Pavel Bondar on 23.12.25.
//

enum Localization: String {
    case configuration_to_stream_title
    case configuration_url_placeholder
    case configuration_key_placeholder
    case configuration_title
    case configuration_url_empty_error
    case configuration_all_fiels_required_error
    case configuration_key_empty_error
    case configuration_incorrect_url_format_error
}

extension Localization {
    
    public var value: String {
        rawValue.localized()
    }
    
}
