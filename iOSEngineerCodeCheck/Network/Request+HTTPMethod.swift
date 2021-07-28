import Foundation

enum HTTPMethod: String {
    case get = "GET"
}

protocol Request {
    associatedtype Response: Decodable

    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: [String: String] { get }
}
