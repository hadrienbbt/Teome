import SwiftUI

extension View {
    public func withBackgoundGradient() -> some View {
        ZStack(alignment: .leading) {
            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.mint]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.vertical)
            self
        }
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
