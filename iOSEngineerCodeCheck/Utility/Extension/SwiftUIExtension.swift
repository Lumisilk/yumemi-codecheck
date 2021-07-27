import SwiftUI

extension Color {
    static var systemGroupedBackground: Color { Color(UIColor.systemGroupedBackground) }
}

extension Binding where Value == Bool {
    /// Mirror a optional binding to bool binding.
    init<T>(optional: Binding<T?>) {
        self = Binding<Bool>(get: {
            optional.wrappedValue != nil
        }, set: { isFalse in
            if isFalse {
                optional.wrappedValue = nil
            }
        })
    }
}

