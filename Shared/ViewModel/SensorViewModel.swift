import SwiftUI

class SensorViewModel: ObservableObject {
    @Published var sensors = ValueStore().sensors {
        didSet {
            ValueStore().sensors = sensors
        }
    }
    @Published var loading = false
    
    func fetchSensors() {
        loading = true
        sensors = [Sensor.sampleHumidity, Sensor.sampleTemperature]
        loading = false
    }
}
