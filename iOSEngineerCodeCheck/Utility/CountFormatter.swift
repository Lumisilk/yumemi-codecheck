import Foundation

func formatCount(count: Int) -> String {
    if count < 1000 {
        return String(count)
    } else {
        return String(format: "%.1fk", Double(count) / 1000)
    }
}
