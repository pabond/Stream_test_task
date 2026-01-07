//
//  MockStorage.swift
//  TestVideoStreaming
//
//  Created by Pavel Bondar on 07.01.26.
//

@testable import TestVideoStreaming

final class MockStorage: StreamingStorage {
    var urlString: String?
    var keyString: String?
}
