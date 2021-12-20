import Foundation
import Firebase
import SwiftUICharts

struct Sample: Identifiable, Decodable, Encodable {
    var id: String
    var type: String
    var value: Double
    var date: Date
    
    init?(id: String, type: String, sample: [String: Any]) {
        guard let value = sample[type] as? Double,
              let updatedAt = sample["updatedAt"] as? Timestamp else {
                  print("❌ Error: Can't read sample \(sample)")
                  return nil
              }
        self.id = id
        self.type = type
        self.value = value
        self.date = updatedAt.dateValue()
    }
}
