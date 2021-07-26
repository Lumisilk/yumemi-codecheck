import UIKit
import Combine

class RepositorySearchViewController: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    let client: Client = GithubClient()
    var cancellable: AnyCancellable?
    var repositories: [Repository] = []
    
    override func viewDidLoad() {
        searchBar.placeholder = "GitHubのリポジトリを検索できるよー"
        searchBar.delegate = self
        searchBar.becomeFirstResponder()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Detail",
           let repositoriy = sender as? Repository,
           let repositoryDetailViewController = segue.destination as? RepositoryDetailViewController {
            repositoryDetailViewController.repository = repositoriy
        }
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
        performSegue(withIdentifier: "Detail", sender: repository)
    }
}

extension RepositorySearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        cancellable?.cancel()
        guard let searchText = searchBar.text,
              !searchText.isEmpty else {
            return
        }
        let request = SearchRepositoriesRequest(query: searchText)
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
