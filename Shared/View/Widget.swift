import SwiftUI
import SwiftUICharts

struct Widget: View {
    @Binding var sensor: Sensor
    @Binding var isSelected: Bool
    
    @Namespace private var widgetEffect
    
    var sampleViewModel: SampleViewModel {
        return SampleViewModel(samples: sensor.samples)
    }
    
    var imageSize: CGFloat {
        return isSelected ? 50 : 40
    }
    
    var image: some View {
        Image(sensor.image)
            .resizable()
            .frame(width: imageSize, height: imageSize)
            .padding([.vertical, .trailing], 5)
    }
    
    var title: some View {
        Text(sensor.title)
            .font(.body)
            .foregroundColor(.secondary)
            .bold()
    }
    
    var value: some View {
        Text("\(sensor.formattedValue) \(sensor.unit)")
            .font(.title)
            .foregroundColor(.primary)
            .bold()
    }
    
    var close: some View {
        Image(systemName: "xmark.circle.fill")
            .resizable()
            .frame(width: 30, height: 30)
            .foregroundStyle(Color.secondary, Color.tertiarySystemBackground)
            .onTapGesture { isSelected = false }
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(.secondarySystemBackground)
            if isSelected {
                VStack {
                    HStack(alignment: .top) {
                        image
                        VStack(alignment: .leading) {
                            title
                            value
                        }
                        Spacer()
                        close
                    }.padding()
                    MultiLineChart(chartData: sampleViewModel.chartData)
                        .sensorChart(chartData: sampleViewModel.chartData)
                        .frame(height: 400)
                        .padding()
                    PlantList()
                }
            } else {
                VStack(alignment: .leading) {
                    image
                    title
                    value
                }.padding()
            }
        }
    }
}

struct Widget_Previews: PreviewProvider {
    static var previews: some View {
        Widget(sensor: .constant(SensorType.humidity.sample), isSelected: .constant(false))
    }
}
