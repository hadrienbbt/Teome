import UserNotifications
import UIKit
import FirebaseFirestore

enum NotificationType: String {
    case disconnected
}

class NotificationManager: NSObject {
    
    let center = UNUserNotificationCenter.current()
    let unpairTimeout: TimeInterval = 60 * 60 * 3

    func configure() {
        guard let deviceId = ValueStore().deviceId else { return }
        UNUserNotificationCenter.current().delegate = self
        askIfNeeded { (status, _) in
            if status == .authorized {
                UIApplication.shared.registerForRemoteNotifications()
                self.configureLocalNotifications(deviceId)
            }
        }
    }
    
    func didRegisterForRemoteNotificationsWithDeviceToken(_ deviceToken: Data) {
        guard let deviceId = ValueStore().deviceId else { return }
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        ValueStore().deviceToken = token
        Firestore
            .firestore()
            .collection("sensors")
            .document(deviceId)
            .setData(["apnDeviceToken": token])
    }
    
    func configureLocalNotifications(_ deviceId: String) {
        center.removeAllPendingNotificationRequests()
        addDisonnectedNotification(deviceId)
    }
    
    func addDisonnectedNotification(_ deviceId: String) {
        let date = Date() + unpairTimeout
        let cmps = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: cmps, repeats: false)
        
        let content = UNMutableNotificationContent()
        content.title = "Appareil \(deviceId) déconnecté"
        content.body = "Rechargez-le ou rétablissez la connexion WiFi"
        
        let id = NotificationType.disconnected.rawValue
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        center.add(request, withCompletionHandler: { error in
            if let error = error {
                print("Error when adding local notification", error)
                return
            }
        })
    }
    
    func askIfNeeded(completion: @escaping (UNAuthorizationStatus, UNAuthorizationStatus) -> Void) {
        center.getNotificationSettings { settings in
            DispatchQueue.main.async {
                let prevStatus = settings.authorizationStatus
                switch prevStatus {
                case .notDetermined:
                    self.center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
                        DispatchQueue.main.async {
                            if granted {
                                completion(.authorized, prevStatus)
                            } else {
                                completion(.denied, prevStatus)
                            }
                        }
                    }
                default:
                    completion(prevStatus, prevStatus)
                }
            }
        }
    }
}

extension NotificationManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("Notification received")
        let options: UNNotificationPresentationOptions = [.badge, .banner, .list, .sound]
        
        if let type = NotificationType(rawValue: notification.request.identifier) {
            switch type {
            case .disconnected:
                guard let sensor = ValueStore().sensors.first,
                   let sample = sensor.samples.first else {
                       print("No sensor or sample")
                       completionHandler(options)
                       return
                }
                if sample.date + unpairTimeout < Date() {
                    completionHandler(options)
                } else {
                    completionHandler([])
                }
            }
        } else {
            print("Remote notification received while app open")
            print(notification.request.identifier)
        }
        completionHandler([])
    }
}
