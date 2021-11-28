import SwiftUI

struct Widget: View {
    @Binding var sensor: Sensor
    @Binding var selectedId: String?
    
    var body: some View {
        NavigationLink(destination: WidgetDetails(sensor: $sensor), tag: sensor.id, selection: $selectedId) {
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(.primary.opacity(0.2))
                HStack {
                    VStack(alignment: .leading) {
                        Image(sensor.image)
                            .resizable()
                            .frame(width: 40, height: 40)
                            .padding(.vertical, 5)
                        Text(sensor.title)
                            .font(.body)
                            .foregroundColor(.primary.opacity(0.6))
                            .bold()
                        Text("\(sensor.formattedValue) \(sensor.unit)")
                            .font(.title)
                            .foregroundColor(.primary)
                            .bold()
                    }
                    .padding()
                }
            }
        }
    }
}

struct Widget_Previews: PreviewProvider {
    static var previews: some View {
        Widget(sensor: .constant(SensorType.humidity.sample), selectedId: .constant(nil))
    }
}
