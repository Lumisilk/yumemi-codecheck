import Foundation

/// An property wrapper to prevent throwing error when decoding empty `String` to `URL`.
@propertyWrapper
struct URLDecoder: Equatable, Decodable {
    var wrappedValue: URL?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let str = try? container.decode(String.self),
           let encoded = str.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
           let url = URL(string: encoded) {
            self.wrappedValue = url
        } else {
            wrappedValue = nil
        }
    }
}
