//
//  StreamViewModelTests.swift
//  TestVideoStreamingTests
//
//  Created by Pavel Bondar on 07.01.26.
//

import XCTest
@testable import TestVideoStreaming

final class StreamViewModelTests: XCTestCase {
    
    @MainActor
    func testTimerFormatting() async {
        let storage = MockStorage()
        let viewModel = StreamViewModel(storage: storage)
        
        XCTAssertNotNil(viewModel)
        
        let expectation = expectation(description: "Timer update callback")
        viewModel.onTimerUpdate = { time in
            XCTAssertEqual(time, "00:00:00")
            expectation.fulfill()
        }
        
        viewModel.stopRunning()
        await fulfillment(of: [expectation], timeout: 1.0)
    }
}
