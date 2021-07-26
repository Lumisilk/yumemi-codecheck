import Foundation

/// Represent a github repository.
struct Repository: Identifiable, Decodable {
    
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
    
    let id: Int
    let name: String
    let fullName: String
    let language: String?
    
    let owner: Owner
    @URLDecoder var htmlUrl: URL?
    @URLDecoder var homepage: URL?
    let description: String
    
    let createdAt: String
    let updatedAt: String
    let pushedAt: String

    let openIssuesCount: Int
    let stargazersCount: Int
    let watchersCount: Int
    let forksCount: Int
    
    let archived: Bool
    let disabled: Bool
    
    let defaultBranch: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case fullName = "full_name"
        case owner
        case htmlUrl = "html_url"
        case description
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case pushedAt = "pushed_at"
        case homepage
        case stargazersCount = "stargazers_count"
        case watchersCount = "watchers_count"
        case language
        case forksCount = "forks_count"
        case archived
        case disabled
        case openIssuesCount = "open_issues_count"
        case defaultBranch = "default_branch"
    }
}
