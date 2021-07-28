import Foundation

enum PreviewData {
    static func get<T: Decodable>(jsonFileName: String) -> T? {
        if let url = Bundle.main.url(forResource: jsonFileName, withExtension: "json"),
           let data = try? Data(contentsOf: url),
           let result = try? JSONDecoder().decode(T.self, from: data) {
            return result
        } else {
            return nil
        }
    }
}
