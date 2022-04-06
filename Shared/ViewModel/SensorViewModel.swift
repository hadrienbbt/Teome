import SwiftUI
import Firebase
import Combine
import FirebaseFirestore

class SensorViewModel: ObservableObject {
    @Published var sensors = ValueStore().sensors {
        didSet {
            ValueStore().sensors = sensors
        }
    }
    @Published var loading: SensorLoadingState?
    @Published var qrcode: String?
    
    var updatedAt: Date? {
        return self.sensors.first?.samples.first?.date
    }
    
    var listener: ListenerRegistration?
    
    func configure() {
        guard let deviceId = ValueStore().deviceId else {
            print("❌ Error: No device SSID")
            return
        }
        print("Configuring for device ID: \(deviceId)")

        listenSensors(deviceId)
        
        ServerCom().getQRCode(deviceId) { qrcode in
            guard let qrcode = qrcode else { return }
            DispatchQueue.main.async {
                self.qrcode = qrcode
            }
        }
    }
    
    func listenSensors(_ deviceId: String) {
        loading = SensorLoadingState.listenSensors
        guard let deviceId = ValueStore().deviceId else {
            print("❌ Error: No device SSID")
            return
        }
        if let listener = listener {
            listener.remove()
        }
        self.listener = Firestore
            .firestore()
            .collection("sensors")
            .document(deviceId)
            .collection("samples")
            .order(by: "updatedAt", descending: true)
            .addSnapshotListener { snap, error in
                guard let docs = snap?.documents else {
                print(error?.localizedDescription ?? "Unknown error")
                return
            }
            if docs.count == 0 {
                self.loading = SensorLoadingState.receivingData
                return
            }
            self.sensors = SensorType
                .allCases
                .map { sensorType in
                    let samples = docs.reduce(into: [Sample]()) { (samples, doc) in
                        if let sample = Sample(id: doc.documentID, type: sensorType.rawValue, sample: doc.data()) {
                            samples.append(sample)
                        }
                    }
                    return Sensor(sensorType: sensorType, samples)
                }
            self.loading = nil
        }
    }
}

enum SensorLoadingState: String {
    case listenSensors = "Chargement des données du capteur"
    case receivingData = "En attente de relevés"
}
