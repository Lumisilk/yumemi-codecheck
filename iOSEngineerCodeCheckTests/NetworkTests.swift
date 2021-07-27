import XCTest
import Combine
@testable import iOSEngineerCodeCheck

class NetworkTests: XCTestCase {

    var client: GithubClient!
    var cancellables: [AnyCancellable] = []
    
    override func setUpWithError() throws {
        client = GithubClient()
        cancellables = []
    }

    func testSearchRepositories() throws {
        let expectation = XCTestExpectation()
        var requestError: Error?
        var searchResult: RepositoriesSearchResult!
        
        let request = RepositoriesSearchRequest(query: "swift")
        client.send(request)
            .sink { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                case .failure(let error):
                    requestError = error
                }
            } receiveValue: { searchResult = $0 }
            .store(in: &cancellables)
        wait(for: [expectation], timeout: 5)
        
        if let error = requestError {
            throw error
        } else {
            XCTAssertEqual(searchResult.repositories.count, 30)
        }
    }
    
    func testSearchRepositoriesCustomPerPage() throws {
        let expectation = XCTestExpectation()
        var requestError: Error?
        var searchResult: RepositoriesSearchResult!
        
        let request = RepositoriesSearchRequest(query: "python", perPage: 5)
        client.send(request)
            .sink { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                case .failure(let error):
                    requestError = error
                }
            } receiveValue: { searchResult = $0 }
            .store(in: &cancellables)
        wait(for: [expectation], timeout: 5)
        
        if let error = requestError {
            throw error
        } else {
            XCTAssertEqual(searchResult.repositories.count, 5)
        }
    }
    
    func testRepository() throws {
        let expectation = XCTestExpectation()
        var requestError: Error?
        var repository: Repository?
        
        let request = RepositoryRequest(ownerName: "apple", repositoryName: "swift")
        client.send(request)
            .sink { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                case .failure(let error):
                    requestError = error
                }
            } receiveValue: {
                repository = $0
            }
            .store(in: &cancellables)
        wait(for: [expectation], timeout: 5)
        
        if let error = requestError {
            throw error
        }
        dump(repository)
    }
}
