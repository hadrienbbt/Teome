import Foundation
import SwiftUI
import FirebaseFirestore
import SwiftUICharts

struct SampleViewModel {
    let samples: [Sample]
    var type: String {
        return samples.first?.type ?? "unknown"
    }
    
    var lineChartData: LineChartData {
        let datapoints = samples.map { LineChartDataPoint(value: $0.value, date: $0.date) }
        let data = LineDataSet(dataPoints: datapoints)
        let chartStyle = LineChartStyle(globalAnimation: .easeOut(duration: 0.2))
        return LineChartData(dataSets: data, chartStyle: chartStyle)
    }
    
    var xAxisLabels: [String] {
        let formatter = SampleRelativeDateFormatter()
        return samples
            .filter { !$0.date.isToday }
            .map { formatter.relativeString($0.date) }
            .deduplicate()
    }
    
    var yAxisLabels: [String] {
        let values = samples
            .map { $0.value }
            .sorted()
        guard let sensorType = SensorType(rawValue: self.type),
              let first = values.first,
              let last = values.last else {
            print("❌ Error: Invalid sensor type", type)
            return []
        }
        let range = (Int(floor(first))...Int(ceil(last)))
        var period = 0
        var labels = [String]()
        repeat {
            labels.removeAll()
            var start = range.lowerBound
            period += 10
            repeat {
                labels.append(String(describing: start))
                start += period
            } while start < range.upperBound
        } while labels.count > 10
        print(type)
        print(labels)
        print(xAxisLabels)
        switch sensorType {
        case .humidity:
            return (0...100)
                .filter { $0 % 10 == 0 }
                .map { "\($0)%" }
        case .temperature:
            return labels
        case .soil:
            return labels
        case .illuminance:
            return labels
        case .pressure:
            return labels
        }
    }
    
    let gradient = [
        GradientStop(color: .green, location: 0),
        GradientStop(color: .yellow, location: 0.33),
        GradientStop(color: .orange, location: 0.66),
        GradientStop(color: .red, location: 1)
    ]
    
    var chartData: MultiLineChartData {
        let sampleLineStyle = LineStyle(lineColour: ColourStyle(stops: gradient, startPoint: .bottom, endPoint: .center), lineType: .curvedLine)
        let datapoints = samples.map { LineChartDataPoint(value: $0.value, date: $0.date) }
        let data = MultiLineDataSet(dataSets: [
            LineDataSet(dataPoints: datapoints, legendTitle: type, style: sampleLineStyle),
        ])

        let gridStyle = GridStyle(
            numberOfLines: yAxisLabels.count,
            lineColour: Color(.systemGray5).opacity(0.5),
            lineWidth: 1,
            dash: [8],
            dashPhase: 0
        )
        let chartStyle = LineChartStyle(
            xAxisGridStyle: gridStyle,
            xAxisLabelColour: .secondary,
            xAxisLabelsFrom: .chartData(rotation: Angle(degrees: 0.0)),
            yAxisGridStyle: gridStyle,
            yAxisLabelColour: .secondary,
            yAxisNumberOfLabels: yAxisLabels.count,
            topLine: .maximumValue,
            globalAnimation: .easeOut(duration: 0.5)
        )
        return MultiLineChartData(
            dataSets: data,
            xAxisLabels: xAxisLabels,
            yAxisLabels: yAxisLabels,
            chartStyle: chartStyle
        )
    }
}
