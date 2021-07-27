import Foundation

/// Represent a github repository.
struct Repository: Decodable {
    
    /// Represent an owner of a repository.
    struct Owner: Identifiable, Decodable {
        let id: Int
        /// The name of this owner.
        let login: String
        @URLDecoder var avatarUrl: URL?
        @URLDecoder var htmlURL: URL?
        
        private enum CodingKeys: String, CodingKey {
            case login
            case id
            case avatarUrl = "avatar_url"
            case htmlURL = "html_url"
        }
    }
    
    struct License: Decodable {
        let key: String
        let name: String
        let spdxId: String
        @URLDecoder var url: URL?
        let nodeId: String
        private enum CodingKeys: String, CodingKey {
            case key
            case name
            case spdxId = "spdx_id"
            case url
            case nodeId = "node_id"
        }
    }

    let id: Int
    let name: String
    let fullName: String
    let owner: Owner
    let description: String
    let language: String?
    let license: License?
    
    @URLDecoder var htmlUrl: URL?
    @URLDecoder var homepage: URL?

    let stargazersCount: Int
    let forksCount: Int
    let openIssuesCount: Int
    let subscribersCount: Int
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case fullName = "full_name"
        case owner
        case description
        case htmlUrl = "html_url"
        case homepage
        case language
        case license

        case stargazersCount = "stargazers_count"
        case forksCount = "forks_count"
        case openIssuesCount = "open_issues_count"
        case subscribersCount = "subscribers_count"
    }
}
