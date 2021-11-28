import SwiftUI
import Firebase

@main
struct Main: App {
    
    init() {
        FirebaseApp.configure()
        UIScrollView.appearance().keyboardDismissMode = .onDrag
    }
    
    var body: some Scene {
        WindowGroup {
            TeomeApp()
        }
    }
}
