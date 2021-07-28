//
//  ViewModelTest.swift
//  iOSEngineerCodeCheckTests
//
//  Created by ribilynn on 2021/07/28.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import XCTest
import Combine
@testable import iOSEngineerCodeCheck

private struct CustomError: Error {}

private final class MockClientForRepositorySearch: Client {

    let result: RepositorySearchResult = PreviewData.get(jsonFileName: "repositories_search_result")!
    var promise: ((Result<RepositorySearchResult, Error>) -> Void)!

    func send<RequestType: Request>(_ request: RequestType) -> AnyPublisher<RequestType.Response, Error> {
        Future { [weak self] promise in
            self?.promise = promise as? (Result<RepositorySearchResult, Error>) -> Void
        }.eraseToAnyPublisher()
    }

    func fulfillResult() {
        promise(.success(result))
    }

    func emitError() {
        promise(.failure(CustomError()))
    }
}

class RepositorySearchViewModelTest: XCTestCase {

    var cancellables: [AnyCancellable] = []

    override func setUpWithError() throws {
        cancellables = []
    }

    func testRepositorySearchViewModel() {
        let client = MockClientForRepositorySearch()
        let viewModel = RepositorySearchViewModel(client: client)

        XCTAssert(viewModel.repositories.value.isEmpty)
        var repositories: [RepositorySearchResult.Repository] = []
        var isLoading = false
        viewModel.isLoading
            .sink { isLoading = $0 }
            .store(in: &cancellables)
        viewModel.repositories
            .sink { repositories = $0 }
            .store(in: &cancellables)

        viewModel.search(text: "swift")
        waitForMainQueue()

        XCTAssertEqual(viewModel.isLoading.value, true)
        XCTAssertEqual(isLoading, true)

        client.fulfillResult()
        waitForMainQueue()

        XCTAssertEqual(viewModel.isLoading.value, false)
        XCTAssertEqual(viewModel.repositories.value.count, client.result.repositories.count)
        XCTAssertEqual(isLoading, false)
        XCTAssertEqual(repositories.count, client.result.repositories.count)
    }

    func testRepositorySearchViewModelError() {
        let client = MockClientForRepositorySearch()
        let viewModel = RepositorySearchViewModel(client: client)

        var isLoading = false
        var error: Error?

        viewModel.isLoading
            .sink { isLoading = $0 }
            .store(in: &cancellables)
        viewModel.errorPublisher
            .sink { error = $0 }
            .store(in: &cancellables)

        viewModel.search(text: "swift")
        waitForMainQueue()

        XCTAssertEqual(viewModel.isLoading.value, true)
        XCTAssertEqual(isLoading, true)

        client.emitError()
        waitForMainQueue()

        XCTAssertEqual(viewModel.isLoading.value, false)
        XCTAssert(viewModel.repositories.value.isEmpty)
        XCTAssertEqual(isLoading, false)
        XCTAssert(error != nil && error! is CustomError)
    }
}
