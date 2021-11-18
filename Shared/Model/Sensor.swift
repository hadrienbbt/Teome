struct Sensor: Identifiable, Decodable, Encodable {
    let id: String
    let image: String
    let title: String
    let value: Int
    let unit: String
    
    static var samples: [Sensor] = [Sensor.sampleHumidity, Sensor.sampleTemperature]
    
    static var sampleHumidity: Sensor {
        return Sensor(id: "0", image: "drop", title: "Humidité", value: 56, unit: "%")
    }
    
    static var sampleTemperature: Sensor {
        return Sensor(id: "1", image: "thermometer", title: "Température", value: 34, unit: "°C")
    }
}
