//
//  Extension.swift
//  iOSEngineerCodeCheckTests
//
//  Created by ribilynn on 2021/07/28.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import XCTest

extension XCTestCase {
    func waitForMainQueue() {
        let expectation = XCTestExpectation(description: "Wait for main")
        DispatchQueue.main.async {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
}
