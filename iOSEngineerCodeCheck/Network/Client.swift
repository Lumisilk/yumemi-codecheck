import Foundation
import Combine

protocol Client {
    func send<RequestType: Request>(_ request: RequestType) -> AnyPublisher<RequestType.Response, Error>
}

struct GithubClient: Client {
    
    let host = "https://api.github.com/search/repositories"
    let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func makeURLRequest<RequestType: Request>(by request: RequestType) -> URLRequest {
        var components = URLComponents(string: host)!
        if !request.parameters.isEmpty {
            components.queryItems = request.parameters.map {
                URLQueryItem(name: $0, value: $1)
            }
            components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        }
        components.path = request.path
        var urlRequest = URLRequest(url: components.url!)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.addValue("application/vnd.github.v3+json", forHTTPHeaderField: "accept")
        return urlRequest
    }
    
    func send<RequestType: Request>(_ request: RequestType) -> AnyPublisher<RequestType.Response, Error> {
        let urlRequest = makeURLRequest(by: request)
        return session.dataTaskPublisher(for: urlRequest)
            .map { $0.data }
            .decode(type: RequestType.Response.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
