import Foundation
import SwiftUI
import FirebaseFirestore
import SwiftUICharts

struct SampleViewModel {
    let samples: [Sample]
    
    var chartData: LineChartData {
        let datapoints = samples.map { LineChartDataPoint(value: $0.value, date: $0.date) }
        let data = LineDataSet(dataPoints: datapoints)
        let chartStyle = LineChartStyle(globalAnimation: .easeOut(duration: 0.2))
        return LineChartData(dataSets: data, chartStyle: chartStyle)
    }
}
