import SwiftUI

struct BackgroundGradient<Content>: View where Content: View {
    
    private var alignment: Alignment
    private var content: () -> Content
    
    public init(alignment: Alignment = .center, content: @escaping () -> Content) {
        self.alignment = alignment
        self.content = content
    }
    
    public var body: some View {
        ZStack(alignment: alignment) {
            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.mint]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.vertical)
            content()
        }
    }
}
