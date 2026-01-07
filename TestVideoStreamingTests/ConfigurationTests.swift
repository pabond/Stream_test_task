//
//  ConfigurationTests.swift
//  TestVideoStreamingTests
//
//  Created by Pavel Bondar on 07.01.26.
//

import XCTest

@testable import TestVideoStreaming

final class ConfigurationTests: XCTestCase {
    
    var storage: MockStorage!
    var sut: ConfigurationViewController! // System Under Test

    override func setUp() {
        super.setUp()
        storage = MockStorage()
        sut = ConfigurationViewController(storage: storage)
        
        _ = sut.view
    }

    func testEmptyFieldsShowError() {
        sut.rootView?.urlTextField.text = ""
        sut.rootView?.keyTextField.text = ""
        
        sut.perform(#selector(ConfigurationViewController.didTapContinue))
        
        XCTAssertFalse(sut.rootView!.errorLabel.isHidden)
        XCTAssertEqual(sut.rootView!.errorLabel.text, Localization.configuration_url_empty_error.value)
    }

    func testInvalidUrlFormat() {
        // incorrect URL
        sut.rootView?.urlTextField.text = "not_rtmp_url"
        sut.rootView?.keyTextField.text = "some_key"
        
        sut.perform(#selector(ConfigurationViewController.didTapContinue))
        
        XCTAssertEqual(sut.rootView!.errorLabel.text, Localization.configuration_incorrect_url_format_error.value)
    }

    func testValidDataSavesToStorage() {
        let validUrl = "rtmp://live.twitch.tv/app"
        let validKey = "live_12345"
        sut.rootView?.urlTextField.text = validUrl
        sut.rootView?.keyTextField.text = validKey
        
        sut.perform(#selector(ConfigurationViewController.didTapContinue))
        
        XCTAssertEqual(storage.urlString, validUrl)
        XCTAssertEqual(storage.keyString, validKey)
    }
}
