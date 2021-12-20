import Foundation
import SwiftUI
import FirebaseFirestore
import SwiftUICharts

class SampleViewModel: ObservableObject {
    @Published var charts = [String: Chart]()
    @Published var loading = false

    var listener: ListenerRegistration?
    
    func getChartData(sensorId: String) -> LineChartData? {
        guard let chart = self.charts[sensorId] else {
                print(sensorId)
            return nil
        }
        let datapoints = chart.samples.map { LineChartDataPoint(value: $0.value, date: $0.date) }
        let data = LineDataSet(dataPoints: datapoints)
        let chartStyle = LineChartStyle(globalAnimation: .easeOut(duration: 0.2))
        print(datapoints)
        return LineChartData(dataSets: data, chartStyle: chartStyle)
    }
    
    var chartData: [String: LineChartData] {
        return charts.mapValues { chart in
            let datapoints = chart.samples.map { LineChartDataPoint(value: $0.value, date: $0.date) }
            let data = LineDataSet(dataPoints: datapoints)
            let chartStyle = LineChartStyle(globalAnimation: .easeOut(duration: 0.2))
            return LineChartData(dataSets: data, chartStyle: chartStyle)
        }
    }
    
    func listenSamples() {
        loading = true
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
            .addSnapshotListener { [self] snap, error in
                guard let snap = snap else {
                    print(error?.localizedDescription ?? "Unknown error")
                    return
                }
                let charts = SensorType.allCases.reduce(into: [String: Chart](), { (charts, type) in
                    charts[type.rawValue] = Chart(id: type.rawValue, samples: [])
                })
                self.charts = charts
                print(self.charts)
//
//                snap.documents.forEach { doc in
//                    let data = doc.data()
//                    guard let updatedAt = data["updatedAt"] as? Timestamp else {
//                        print("❌ Error: No date for sample \(data)")
//                        return
//                    }
//                    SensorType.allCases.forEach { sensorType in
//                        guard let value = data[sensorType.rawValue] as? Double else {
//                            print("❌ Error: No value for sample \(data)")
//                            return
//                        }
//                        let sample = Sample(id: doc.documentID, value: value, date: updatedAt.dateValue())
//                        if charts[sensorType.rawValue] == nil {
//                            charts[sensorType.rawValue] = Chart(id: sensorType.rawValue, samples: [sample])
//                        } else {
//                            charts[sensorType.rawValue]!.samples.append(sample)
//                        }
//                    }
//                }
                loading = false
            }
    }
}
