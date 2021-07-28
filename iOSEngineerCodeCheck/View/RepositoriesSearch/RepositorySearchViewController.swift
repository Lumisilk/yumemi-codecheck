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
        configureTableView()
        subscribe()
    }
    
    private func configureSearchController() {
        let searchController = UISearchController()
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search repositories"
        searchController.searchBar.showsCancelButton = false
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }
    
    private func configureTableView() {
        tableView.register(RepositorySearchResultCell.self)
        tableView.keyboardDismissMode = .onDrag
    }
    
    private func subscribe() {
        viewModel.isLoading.combineLatest(viewModel.repositories)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.errorPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.presentError(error)
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
        if viewModel.isLoading.value {
            return viewModel.repositories.value.count + 1
        } else {
            return viewModel.repositories.value.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == viewModel.repositories.value.count {
            // loading cell
            return LoadingCell(style: .default, reuseIdentifier: nil)
        } else {
            // repository cell
            let cell = tableView.dequeueReusableCell(RepositorySearchResultCell.self)
            let repository = viewModel.repositories.value[indexPath.row]
            cell.configure(repository: repository)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        indexPath.row < viewModel.repositories.value.count ? indexPath: nil
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < viewModel.repositories.value.count else {
            return
        }
        let repository = viewModel.repositories.value[indexPath.row]
        let viewModel = RepositoryViewModel(client: viewModel.client, ownerName: repository.owner.login, repositoryName: repository.name)
        let view = RepositoryView(viewModel: viewModel)
        let viewController = UIHostingController(rootView: view)
        viewController.title = repository.name
        show(viewController, sender: nil)
    }
}

// MARK: - UISearchBarDelegate
extension RepositorySearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text, !searchText.isEmpty {
            viewModel.search(text: searchText)
        }
    }
}

#if DEBUG
struct RepositorySearchViewControllerRepresentable: UIViewControllerRepresentable {
    
    final class MockRepositorySearchViewModel: RepositorySearchViewModelProtocol {
        
        let client: Client = GithubClient()
        
        let isLoading = CurrentValueSubject<Bool, Never>(true)
        let repositories = CurrentValueSubject<[RepositorySearchResult.Repository], Never>([])
        @Published var error: Error?
        
        var errorPublisher: AnyPublisher<Error, Never> {
            $error.compactMap { $0 }.eraseToAnyPublisher()
        }
        init(delay: Double) {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                let searchResult: RepositorySearchResult = PreviewData.get(jsonFileName: "repositories_search_result")!
                self.repositories.send(searchResult.repositories)
                self.isLoading.send(false)
            }
        }
        
        func search(text: String) {}
    }
    
    let delay: Double
    
    func makeUIViewController(context: Context) -> UINavigationController {
        UINavigationController(rootViewController: RepositorySearchViewController(viewModel: MockRepositorySearchViewModel(delay: delay)))
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        
    }
}

struct RepositorySearchViewControllerPreview: PreviewProvider {
    static var previews: some View {
        RepositorySearchViewControllerRepresentable(delay: 1)
    }
}
#endif
