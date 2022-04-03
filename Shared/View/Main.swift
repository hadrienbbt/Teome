import SwiftUI
import Firebase

@main
struct Main: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
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

class AppDelegate: NSObject, UIApplicationDelegate {
    
    let notificationManager = NotificationManager()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = notificationManager
        notificationManager.isNotificationEnabled { isEnabled in
            if !isEnabled { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) async -> UIBackgroundFetchResult {
        print("didReceiveRemoteNotification")
        print(userInfo)
        return .newData
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        ValueStore().deviceToken = token
        notificationManager.saveDeviceToken(token)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("didFailToRegisterForRemoteNotificationsWithError")
        print(error)
    }
}
