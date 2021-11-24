import SwiftUI

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
