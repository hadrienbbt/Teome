import SwiftUI

struct Widget: View {
    @Binding var sensor: Sensor
    @Binding var selectedId: String?
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(.secondarySystemBackground)
            VStack(alignment: .leading) {
                Image(sensor.image)
                    .resizable()
                    .frame(width: 40, height: 40)
                    .padding(.vertical, 5)
                Text(sensor.title)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .bold()
                Text("\(sensor.formattedValue) \(sensor.unit)")
                    .font(.title)
                    .foregroundColor(.primary)
                    .bold()
            }.padding()
        }
    }
}

struct Widget_Previews: PreviewProvider {
    static var previews: some View {
        Widget(sensor: .constant(SensorType.humidity.sample), selectedId: .constant(nil))
    }
}
