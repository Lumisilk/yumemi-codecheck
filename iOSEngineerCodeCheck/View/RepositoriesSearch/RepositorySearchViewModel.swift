import Combine
import Foundation

protocol RepositorySearchViewModelProtocol {
    var client: Client { get }
    var isLoading: CurrentValueSubject<Bool, Never> { get }
    var repositories: CurrentValueSubject<[RepositorySearchResult.Repository], Never> { get }
    var errorPublisher: AnyPublisher<Error, Never> { get }
    func search(text: String)
    func reset()
}

final class RepositorySearchViewModel: RepositorySearchViewModelProtocol {
    
    let client: Client
    var cancellable: AnyCancellable?
    
    let isLoading = CurrentValueSubject<Bool, Never>(false)
    let repositories = CurrentValueSubject<[RepositorySearchResult.Repository], Never>([])
    @Published var error: Error?
    
    var errorPublisher: AnyPublisher<Error, Never> {
        $error.compactMap { $0 }.eraseToAnyPublisher()
    }
    
    init(client: Client) {
        self.client = client
    }
    
    func search(text: String) {
        reset()
        isLoading.send(true)
        let request = RepositorySearchRequest(query: text)
        cancellable = client.send(request)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.error = error
                    print(error)
                }
                self?.isLoading.send(false)
            }, receiveValue: { [weak self] searchResult in
                self?.repositories.send(searchResult.repositories)
            })
    }
    
    func reset() {
        repositories.send([])
    }
}
