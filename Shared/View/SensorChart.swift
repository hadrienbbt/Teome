import SwiftUI
import Charts

struct SensorChart: View {
    var sensor: Sensor
    
    let gradientStops: [Gradient.Stop] = [
        Gradient.Stop(color: .green, location: 0),
        Gradient.Stop(color: .yellow, location: 0.33),
        Gradient.Stop(color: .orange, location: 0.66),
        Gradient.Stop(color: .red, location: 1),
    ]
    
    var body: some View {
        Chart {
            ForEach(sensor.samples, id: \.id) {
                LineMark(
                    x: .value("Heure", $0.date, unit: .hour),
                    y: .value("Valeur", $0.value)
                )
                .foregroundStyle(
                    .linearGradient(
                        stops: gradientStops,
                        startPoint: .bottom,
                        endPoint: .top
                    )
                )
                .lineStyle(StrokeStyle(lineWidth: 3))
                .interpolationMethod(.catmullRom)
            }
        }
        .chartYAxisLabel(sensor.unit)
        .frame(height: 250)
        .padding()
    }
}

struct SensorChart_Previews: PreviewProvider {
    static var previews: some View {
        SensorChart(sensor: SensorViewModel().sensors.first!)
    }
}
