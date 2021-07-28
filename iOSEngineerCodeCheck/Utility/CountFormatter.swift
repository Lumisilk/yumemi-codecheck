import Foundation

/// format integer 1145 to string "1.1k" if that integer is greater than 1000.
func formatCount(count: Int) -> String {
    if count < 1000 {
        return String(count)
    } else {
        return String(format: "%.1fk", Double(count) / 1000)
    }
}
