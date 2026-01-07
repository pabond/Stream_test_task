//
//  TestVideoStreamingTests.swift
//  TestVideoStreamingTests
//
//  Created by Pavel Bondar on 21.12.25.
//

import Testing
import Foundation
@testable import TestVideoStreaming

struct TestVideoStreamingTests {

    // MARK: - Regex Tests
    @Test("Valid RTMP links check")
    func validateCorrectUrls() {
        let urls = [
            "rtmp://live.twitch.tv/app",
            "rtmps://live-api-s.facebook.com:443/rtmp/",
            "rtmp://1.1.1.1/live"
        ]
        
        for url in urls {
            #expect(url.isValidStreamingUrl == true, "URL \(url) should be valid")
        }
    }

    @Test("Invalid links check")
    func validateIncorrectUrls() {
        let urls = [
            "http://google.com",
            "rtmp://",
            "not_a_url"
        ]
        
        for url in urls {
            #expect(url.isValidStreamingUrl == false, "URL \(url) should be invalid")
        }
    }

    // MARK: - Storage Tests
    @Test("Save data in UserDefaults")
    func storageSaving() {
        let storage = UserDefaultsStorage(defaults: .standard)
        let testUrl = "rtmp://test.com/live"
        
        storage.urlString = testUrl
        
        #expect(storage.urlString == testUrl)
    }
}
