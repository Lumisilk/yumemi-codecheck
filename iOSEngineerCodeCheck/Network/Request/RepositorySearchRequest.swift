import Foundation

/// An request to search github repositories. The response is `RepositoriesSearchResult`.
struct RepositorySearchRequest: Request {
    
    enum SortType: String {
        case stars
        case forks
        case issues = "help-wanted-issues"
        case updated
    }
    
    typealias Response = RepositorySearchResult
    let method: HTTPMethod = .get
    let path: String = "/search/repositories"
    var parameters: [String : String] = [:]
    
    /// Make a RepositoriesSearchRequest.
    /// - Parameters:
    ///   - query: The query contains one or more search keywords and qualifiers. Qualifiers allow you to limit your search to specific areas of GitHub.
    ///   - sortType: Sorts the results of your query by number of `stars`, `forks`, or `help-wanted-issues` or how recently the items were `updated`.
    ///   - isAscending: Determines whether the search result is in ascending order.
    ///   - perPage: Results per page (max 100). Default: 30.
    ///   - page: Page number of the results to fetch. Default: 1.
    init(
        query: String,
        sortType: SortType? = nil,
        isAscending: Bool = false,
        perPage: Int? = nil,
        page: Int? = nil
    ) {
        parameters["q"] = query
        if let sortType = sortType {
            parameters["sort"] = sortType.rawValue
            if isAscending {
                parameters["order"] = "asc"
            }
        }
        parameters["per_page"] = perPage.map(String.init)
        parameters["page"] = page.map(String.init)
    }
}
