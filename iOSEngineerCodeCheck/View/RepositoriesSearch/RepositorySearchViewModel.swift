import Combine
import Foundation

protocol RepositorySearchViewModelProtocol {
    var client: Client { get }
    var isLoadingPublisher: AnyPublisher<Bool, Never> { get }
    var errorPublisher: AnyPublisher<Error, Never> { get }
    var repositories: CurrentValueSubject<[RepositorySearchResult.Repository], Never> { get }
    func search(text: String)
}

final class RepositorySearchViewModel: RepositorySearchViewModelProtocol {
    
    let client: Client
    var cancellable: AnyCancellable?
    
    @Published var isLoading = false
    @Published var error: Error?
    let repositories = CurrentValueSubject<[RepositorySearchResult.Repository], Never>([])
    
    var isLoadingPublisher: AnyPublisher<Bool, Never> {
        $isLoading.eraseToAnyPublisher()
    }
    
    var errorPublisher: AnyPublisher<Error, Never> {
        $error.compactMap { $0 }.eraseToAnyPublisher()
    }
    
    init(client: Client) {
        self.client = client
    }
    
    func search(text: String) {
        isLoading = true
        let request = RepositorySearchRequest(query: text)
        cancellable = client.send(request)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.error = error
                }
                self?.isLoading = false
            }, receiveValue: { [weak self] searchResult in
                self?.repositories.send(searchResult.repositories)
            })
    }
}
