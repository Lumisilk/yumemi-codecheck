import XCTest

extension XCTestCase {
    /// Wait for main queue to execute the code to prevent race condition.
    func waitForMainQueue() {
        let expectation = XCTestExpectation(description: "Wait for main")
        DispatchQueue.main.async {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
}
