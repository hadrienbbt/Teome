import UserNotifications

enum NotificationType: String {
    case unpair
}

class NotificationManager: NSObject {
    
    let center = UNUserNotificationCenter.current()
    let unpairTimeout: TimeInterval = 3600
    
    func askIfNeeded(completion: @escaping (UNAuthorizationStatus, UNAuthorizationStatus) -> Void) {
        center.getNotificationSettings { settings in
            DispatchQueue.main.async {
                let prevStatus = settings.authorizationStatus
                switch prevStatus {
                case .notDetermined:
                    self.center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
                        if granted {
                            completion(.authorized, prevStatus)
                        } else {
                            completion(.denied, prevStatus)
                        }
                    }
                default:
                    completion(prevStatus, prevStatus)
                }
            }
        }
    }
    
    func isNotificationEnabled(completion: @escaping (Bool) -> Void) {
        center.getNotificationSettings { settings in
            let isEnabled = settings.authorizationStatus == .authorized
            completion(isEnabled)
        }
    }
    
    func resetLocalNotifications() {
        center.removeAllPendingNotificationRequests()
        center.getNotificationSettings(completionHandler: { settings in
            DispatchQueue.main.async {
                if settings.authorizationStatus == .authorized {
                    self.setupUnpairedNotification()
                } else {
                    self.askIfNeeded { (status, _) in
                        if status == .authorized {
                            self.setupUnpairedNotification()
                        }
                    }
                }
            }
        })
    }
    
    func setupUnpairedNotification() {
        let date = Date() + unpairTimeout
        let cmps = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: cmps, repeats: false)
        
        let content = UNMutableNotificationContent()
        content.title = "Appareil déconnecté"
        content.body = "Rechargez-le ou rétablissez la connexion WiFi"
        
        let id = NotificationType.unpair.rawValue
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        center.add(request, withCompletionHandler: { error in
            if let error = error {
                print("Error when adding local notification", error)
                return
            }
        })
    }
}

extension NotificationManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("Notification received")
        let options: UNNotificationPresentationOptions = [.badge, .banner, .list, .sound]
        
        if let type = NotificationType(rawValue: notification.request.identifier) {
            switch type {
            case .unpair:
                self.setupUnpairedNotification()
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
        }
        completionHandler([])
    }
}
