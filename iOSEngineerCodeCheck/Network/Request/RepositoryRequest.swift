import Foundation

/// An request to fetch the detail of a repository.
struct RepositoryRequest: Request {
    typealias Response = Repository

    let method: HTTPMethod = .get
    let path: String
    let parameters: [String: String] = [:]

    init(ownerName: String, repositoryName: String) {
        path = "/repos/\(ownerName)/\(repositoryName)"
    }
}
