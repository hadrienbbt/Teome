import SwiftUI
import Firebase

@main
struct Main: App {
    
    @ObservedObject var locationViewModel = LocationViewModel()
    
    init() {
        FirebaseApp.configure()
        UIScrollView.appearance().keyboardDismissMode = .onDrag
        locationViewModel.requestAuthorisation()
    }
    
    var body: some Scene {
        WindowGroup {
            if locationViewModel.allowed {
                TeomeApp()
            } else {
                Text("Autorisez la localisation dans les réglages")
                    .padding(.bottom)
                Button("Ouvrir Réglages", action: {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)

                })
            }
        }
    }
}
