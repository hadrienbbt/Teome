import SwiftUI
import Firebase

@main
struct TeomeApp: App {
    
    init() {
        FirebaseApp.configure()
        UIScrollView.appearance().keyboardDismissMode = .onDrag
    }
    
    var body: some Scene {
        WindowGroup {
            PairDevice()
            // SensorList()
        }
    }
}
