import Combine
import Foundation

protocol RepositorySearchViewModelProtocol {
    var client: Client { get }
    var isLoading: CurrentValueSubject<Bool, Never> { get }
    var repositories: CurrentValueSubject<[RepositorySearchResult.Repository], Never> { get }
    var errorPublisher: AnyPublisher<Error, Never> { get }
    func search(text: String)
}

final class RepositorySearchViewModel: RepositorySearchViewModelProtocol {

    let client: Client
    private var cancellable: AnyCancellable?

    let isLoading = CurrentValueSubject<Bool, Never>(false)
    let repositories = CurrentValueSubject<[RepositorySearchResult.Repository], Never>([])
    private let error = PassthroughSubject<Error, Never>()
    var errorPublisher: AnyPublisher<Error, Never> { error.eraseToAnyPublisher() }

    init(client: Client) {
        self.client = client
    }

    func search(text: String) {
        reset()
        isLoading.value = true
        let request = RepositorySearchRequest(query: text)
        cancellable = client.send(request)
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.error.send(error)
                    print(error)
                }
                self?.isLoading.value = false
            }, receiveValue: { [weak self] searchResult in
                self?.repositories.value = searchResult.repositories
            })
    }

    private func reset() {
        repositories.send([])
    }
}
