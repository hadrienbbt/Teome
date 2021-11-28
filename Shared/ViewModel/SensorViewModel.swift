import SwiftUI
import Firebase
import Combine
import FirebaseFirestore

typealias Completion<R> = (Error?, R?) -> Void

class SensorViewModel: ObservableObject {
    @Published var sensors = ValueStore().sensors {
        didSet {
            ValueStore().sensors = sensors
        }
    }
    @Published var loading: String?
    
    var listener: ListenerRegistration?
    
    func listenSensors() {
        loading = "Chargement des données du capteur"
        guard let deviceId = ValueStore().deviceId else {
            print("❌ Error: No device SSID")
            return
        }
        if let listener = listener {
            listener.remove()
        }
        print("Device ID: \(deviceId)")
        self.listener = Firestore
            .firestore()
            .collection("sensors")
            .document(deviceId)
            .addSnapshotListener { snap, error in
                guard let snap = snap else {
                    print(error?.localizedDescription ?? "Unknown error")
                    return
                }
                if !snap.exists {
                    self.loading = "En attente de relevés"
                    return
                }
                guard let value = snap.data() else { return }
                self.sensors = SensorType
                    .allCases
                    .map {
                        var sensor = Sensor(sensorType: $0)
                        guard let value = value[sensor.id] as? Double else {
                            print("❌ Error: Can't find value of type \(sensor.id)")
                            return sensor
                        }
                        sensor.value = value
                        print("\(sensor.title): \(sensor.value)")
                        return sensor
                    }
                self.loading = nil
            }
    }
}
