//
//  RepositoryViewModelTest.swift
//  iOSEngineerCodeCheckTests
//
//  Created by ribilynn on 2021/07/28.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import XCTest
import Combine
@testable import iOSEngineerCodeCheck

private struct CustomError: Error {}
extension Repository: Equatable {
    public static func == (lhs: Repository, rhs: Repository) -> Bool {
        lhs.id == rhs.id
    }
}

private final class MockClientForRepository: Client {

    let result: Repository = PreviewData.get(jsonFileName: "repository")!
    var promise: ((Result<Repository, Error>) -> Void)!

    func send<RequestType: Request>(_ request: RequestType) -> AnyPublisher<RequestType.Response, Error> {
        Future { [weak self] promise in
            self?.promise = promise as? (Result<Repository, Error>) -> Void
        }.eraseToAnyPublisher()
    }

    func fulfillResult() {
        promise(.success(result))
    }

    func emitError() {
        promise(.failure(CustomError()))
    }
}

class RepositoryViewModelTest: XCTestCase {

    var cancellables: [AnyCancellable] = []

    override func setUpWithError() throws {
        cancellables = []
    }

    func testRepositoryViewModel() throws {
        let client = MockClientForRepository()
        let viewModel = RepositoryViewModel(client: client, ownerName: "apple", repositoryName: "swift")

        var repository: Repository?
        var isLoading = false
        viewModel.$isLoading
            .sink { isLoading = $0 }
            .store(in: &cancellables)
        viewModel.$repository
            .sink { repository = $0 }
            .store(in: &cancellables)

        viewModel.loadRepository()
        waitForMainQueue()

        XCTAssertEqual(viewModel.isLoading, true)
        XCTAssertEqual(isLoading, true)

        client.fulfillResult()
        waitForMainQueue()

        XCTAssertEqual(viewModel.isLoading, false)
        XCTAssertEqual(viewModel.repository, client.result)
        XCTAssertEqual(isLoading, false)
        XCTAssertEqual(repository, client.result)
    }

    func testRepositorySearchViewModelError() throws {
        let client = MockClientForRepository()
        let viewModel = RepositoryViewModel(client: client, ownerName: "apple", repositoryName: "swift")

        var isLoading = false
        var error: Error?
        viewModel.$isLoading
            .sink { isLoading = $0 }
            .store(in: &cancellables)
        viewModel.$error
            .sink { error = $0 }
            .store(in: &cancellables)

        viewModel.loadRepository()
        waitForMainQueue()

        XCTAssertEqual(viewModel.isLoading, true)
        XCTAssertEqual(isLoading, true)

        client.emitError()
        waitForMainQueue()

        XCTAssertEqual(viewModel.isLoading, false)
        XCTAssert(viewModel.error != nil && viewModel.error! is CustomError)
        XCTAssertEqual(isLoading, false)
        XCTAssert(error != nil && error! is CustomError)
    }
}
