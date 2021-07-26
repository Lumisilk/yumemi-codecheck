import UIKit

class RepositoryDetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var starCountLabel: UILabel!
    @IBOutlet weak var watchCountLabel: UILabel!
    @IBOutlet weak var forkCountLabel: UILabel!
    @IBOutlet weak var issueCountLabel: UILabel!
    
    var repository: Repository?
        
    override func viewDidLoad() {
        getImage()
        configure()
    }
    
    private func configure() {
        titleLabel.text = repository?.fullName
        languageLabel.text = repository?.language
        starCountLabel.text = "Stats: \(repository?.stargazersCount ?? 0)"
        watchCountLabel.text = "Watches: \(repository?.watchersCount ?? 0)"
        forkCountLabel.text = "Forks: \(repository?.forksCount ?? 0)"
        issueCountLabel.text = "Open Issues: \(repository?.openIssuesCount ?? 0)"
    }
    
    func getImage() {
        guard let repository = repository,
              let avatarURL = repository.owner.avatarUrl else {
            return
        }
        URLSession.shared.dataTask(with: avatarURL) { (data, response, error) in
            if let image = data.map(UIImage.init) {
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
        }.resume()
    }
}
