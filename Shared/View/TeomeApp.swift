import SwiftUI
import Firebase

@main
struct TeomeApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            SensorList()
        }
    }
}
