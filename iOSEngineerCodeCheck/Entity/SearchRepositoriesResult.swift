import Foundation

/// Represent the result of searching repositories.
struct SearchRepositoriesResult: Decodable {
    let totalCount: Int
    let incompleteResults: Bool
    let repositories: [Repository]
    
    private enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case repositories = "items"
    }
}
