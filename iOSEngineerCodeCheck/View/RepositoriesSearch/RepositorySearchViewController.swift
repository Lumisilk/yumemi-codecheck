import UIKit
import Combine
import SwiftUI

class RepositorySearchViewController: UITableViewController {

    let viewModel: RepositorySearchViewModelProtocol
    var cancellables: [AnyCancellable] = []
    
    init(viewModel: RepositorySearchViewModelProtocol) {
        self.viewModel = viewModel
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        title = "Github Repositories"
        configureSearchController()
        subscribe()
    }
    
    private func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search repositories"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }
    
    private func subscribe() {
        viewModel.isLoadingPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                
            }
            .store(in: &cancellables)
        
        viewModel.errorPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.presentError(error)
            }
            .store(in: &cancellables)
        
        viewModel.repositories
            .receive(on: DispatchQueue.main)
            .sink { [weak self] repositories in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    private func presentError(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: UITableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.repositories.value.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let repository = viewModel.repositories.value[indexPath.row]
        cell.textLabel?.text = repository.fullName
        cell.detailTextLabel?.text = repository.language
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let repository = viewModel.repositories.value[indexPath.row]
        let viewModel = RepositoryViewModel(client: viewModel.client, ownerName: repository.owner.login, repositoryName: repository.name)
        let view = RepositoryView(viewModel: viewModel)
        let viewController = UIHostingController(rootView: view)
        viewController.title = repository.owner.login
        show(viewController, sender: nil)
    }
}

extension RepositorySearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text, !searchText.isEmpty {
            viewModel.search(text: searchText)
        }
    }
}

#if DEBUG
private struct RepositorySearchViewControllerRepresentable: UIViewControllerRepresentable {
    
    final class MockRepositorySearchViewModel: RepositorySearchViewModelProtocol {
        
        let client: Client = GithubClient()
        
        @Published var isLoading = true
        @Published var error: Error?
        let repositories = CurrentValueSubject<[RepositorySearchResult.Repository], Never>([])
        
        var isLoadingPublisher: AnyPublisher<Bool, Never> {
            $isLoading.eraseToAnyPublisher()
        }
        
        var errorPublisher: AnyPublisher<Error, Never> {
            $error.compactMap { $0 }.eraseToAnyPublisher()
        }
        init() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                let searchResult: RepositorySearchResult = PreviewData.get(jsonFileName: "repositories_search_result")!
                self.repositories.send(searchResult.repositories)
                self.isLoading = false
            }
        }
        
        func search(text: String) {}
    }
    
    func makeUIViewController(context: Context) -> UINavigationController {
        UINavigationController(rootViewController: RepositorySearchViewController(viewModel: MockRepositorySearchViewModel()))
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        
    }
}

struct RepositorySearchViewControllerPreview: PreviewProvider {
    static var previews: some View {
        RepositorySearchViewControllerRepresentable()
    }
}
#endif
