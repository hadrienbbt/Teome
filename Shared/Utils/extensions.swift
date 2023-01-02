import SwiftUI
import UIKit

extension View {
    public func withBackgoundGradient(alignment: Alignment = .center) -> some View {
        BackgroundGradient(alignment: alignment) { self }
    }
    
    public func withScrollable(_ axis: Axis.Set, showsIndicators: Bool) -> some View {
        ScrollView(axis, showsIndicators: showsIndicators) {
            self
        }
    }
    
    public func withScrollableBackgroundGradient(_ axis: Axis.Set, showsIndicators: Bool, alignment: Alignment = .center) -> some View {
        self
            .withBackgoundGradient(alignment: alignment)
            .withScrollable(axis, showsIndicators: showsIndicators)
    }
    
    @ViewBuilder
    func `if`<Content: View>(_ conditional: Bool, content: (Self) -> Content) -> some View {
         if conditional {
             content(self)
         } else {
             self
         }
     }
}

extension Image {
    init?(base64String: String) {
        guard let url = URL(string: base64String),
              let data = try? Data(contentsOf: url),
              let uiImage = UIImage(data: data) else { return nil}
        self = Image(uiImage: uiImage)
    }
}

extension Array where Element: Hashable {
    func deduplicate() -> Array {
        return Array(Set(self))
    }
}

extension Date {
    
    var isToday: Bool {
        return Calendar.current.dateComponents([.day], from: self, to: Date()).day == 0
    }
    
    var timeAgo: String {
        let calendar = Calendar.current
        let minuteAgo = calendar.date(byAdding: .minute, value: -1, to: Date())!
        let hourAgo = calendar.date(byAdding: .hour, value: -1, to: Date())!
        let dayAgo = calendar.date(byAdding: .day, value: -1, to: Date())!
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date())!

        if minuteAgo < self {
            // let diff = Calendar.current.dateComponents([.second], from: self, to: Date()).second ?? 0
            return "À l'instant"
        } else if hourAgo < self {
            let diff = Calendar.current.dateComponents([.minute], from: self, to: Date()).minute ?? 0
            return "Il y a \(diff) min"
        } else if dayAgo < self {
            let diff = Calendar.current.dateComponents([.hour], from: self, to: Date()).hour ?? 0
            return "Il y a \(diff) h"
        } else if weekAgo < self {
            let diff = Calendar.current.dateComponents([.day], from: self, to: Date()).day ?? 0
            return "Il y a \(diff) jours"
        }
        let diff = Calendar.current.dateComponents([.weekOfYear], from: self, to: Date()).weekOfYear ?? 0
        return "Il y a \(diff) semaines"
    }
}

extension Color {
    static let lightText = Color(UIColor.lightText)
    static let darkText = Color(UIColor.darkText)

    static let label = Color(UIColor.label)
    static let secondaryLabel = Color(UIColor.secondaryLabel)
    static let tertiaryLabel = Color(UIColor.tertiaryLabel)
    static let quaternaryLabel = Color(UIColor.quaternaryLabel)

    static let systemBackground = Color(UIColor.systemBackground)
    static let secondarySystemBackground = Color(UIColor.secondarySystemBackground)
    static let tertiarySystemBackground = Color(UIColor.tertiarySystemBackground)

    // There are more..
}
