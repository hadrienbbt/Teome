import Foundation

struct Sensor: Identifiable, Decodable, Encodable {
    let id: String
    let image: String
    let imageType: String
    let title: String
    var value: Double
    let unit: String
    var samples: [Sample]
    
    var type: SensorType {
        return SensorType(rawValue: id)!
    }
    
    var formattedValue: String {
        return String(format: "%.0f", round(value))
    }
    
    init(sensorType: SensorType, _ samples: [Sample]) {
        self.id = sensorType.rawValue
        self.samples = samples
        self.value = samples.first?.value ?? 0
        switch sensorType {
        case .humidity:
            self.image = self.value == -8000 ? "drop.degreesign.slash" :
                self.value < 50 ? "drop.degreesign" :
                "drop.degreesign.fill"
            self.imageType = "sfSymbol"
            self.title = "Humidité"
            self.unit = "%"
        case .temperature:
            self.image = self.value == -8000 ? "thermometer.medium.slash" :
                self.value < 15 ? "thermometer.low" :
                self.value < 25 ? "thermometer.medium" :
                "thermometer.high"
            self.imageType = "sfSymbol"
            self.title = "Température"
            self.unit = "°C"
        case .illuminance:
            self.image = self.value < 100 ? "moon.fill" :
                self.value < 1000 ? "sun.max" :
                "sun.max.fill"
            self.imageType = "sfSymbol"
            self.title = "Luminosité"
            self.unit = "lux"
        case .pressure:
            self.image = "pressure"
            self.imageType = "custom"
            self.title = "Pression"
            self.unit = "mbar"
        case .soil:
            self.image = "plant"
            self.imageType = "custom"
            self.title = "Plante"
            self.unit = "%"
        }
    }
}

enum SensorType: String, CaseIterable {
    case humidity
    case temperature
    case soil
    case illuminance
    case pressure
    
    static var samples: [Sensor] = SensorType.allCases.map { $0.sample }
    
    var sample: Sensor {
        var sensor = Sensor(sensorType: self, [])
        switch self {
        case .humidity:
            sensor.value = 56
        case .temperature:
            sensor.value = 34
        case .illuminance:
            sensor.value = 300
        case .pressure:
            sensor.value = 1000
        case .soil:
            sensor.value = 80
        }
        return sensor
    }
}
