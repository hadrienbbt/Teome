struct Sensor: Identifiable, Decodable, Encodable {
    let id: String
    let image: String
    let title: String
    let value: Int
    let unit: String
    
    static var samples: [Sensor] = [.sampleHumidity, .sampleTemperature, .sampleLight]
    
    static var sampleHumidity: Sensor {
        return Sensor(id: "0", image: "drop", title: "Humidité", value: 56, unit: "%")
    }
    
    static var sampleTemperature: Sensor {
        return Sensor(id: "1", image: "thermometer", title: "Température", value: 34, unit: "°C")
    }
    
    static var sampleLight: Sensor {
        return Sensor(id: "2", image: "sun", title: "Luminosité", value: 300, unit: "lux")
    }
}
