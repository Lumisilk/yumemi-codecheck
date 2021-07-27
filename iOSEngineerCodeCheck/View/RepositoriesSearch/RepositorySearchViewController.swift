import UIKit
import Combine
import SwiftUI

class RepositorySearchViewController: UITableViewController {

    let client: Client = GithubClient()
    var cancellable: AnyCancellable?
    var repositories: [RepositoriesSearchResult.Repository] = []
    
    override func viewDidLoad() {
        title = "Github Repositories"
        configureSearchController()
    }
    
    private func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search repositories"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }
    
    // MARK: UITableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        repositories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let repository = repositories[indexPath.row]
        cell.textLabel?.text = repository.fullName
        cell.detailTextLabel?.text = repository.language
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let repository = repositories[indexPath.row]
        let viewModel = RepositoryViewModel(client: client, ownerName: repository.owner.login, repositoryName: repository.name)
        let view = RepositoryView(viewModel: viewModel)
        let viewController = UIHostingController(rootView: view)
        viewController.title = repository.owner.login
        show(viewController, sender: nil)
    }
}

extension RepositorySearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text,
              !searchText.isEmpty else {
            return
        }
        
        let request = RepositoriesSearchRequest(query: searchText)
        cancellable = client.send(request)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                }
            }, receiveValue: { [weak self] searchRepositoriesResult in
                self?.repositories = searchRepositoriesResult.repositories
                self?.tableView.reloadData()
            })
    }
}
