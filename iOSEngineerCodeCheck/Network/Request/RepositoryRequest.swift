import Foundation

struct RepositoryRequest: Request {
    typealias Response = Repository

    let method: HTTPMethod = .get
    let path: String
    let parameters: [String: String] = [:]

    init(ownerName: String, repositoryName: String) {
        path = "/repos/\(ownerName)/\(repositoryName)"
    }
}
