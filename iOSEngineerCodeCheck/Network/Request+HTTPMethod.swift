import Foundation

enum HTTPMethod: String {
    case get = "GET"
}

/// Represents a request to the Github API.
protocol Request {
    associatedtype Response: Decodable

    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: [String: String] { get }
}
