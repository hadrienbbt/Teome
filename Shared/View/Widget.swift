import SwiftUI

struct Widget: View {
    @Binding var sensor: Sensor
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Rectangle()
                .frame(width: 140, height: 140)
                .cornerRadius(20)
            VStack(alignment: .leading) {
                Image(sensor.image)
                    .resizable()
                    .frame(width: 40, height: 40)
                    .padding(.vertical, 5)
                Text(sensor.title)
                    .font(.body)
                    .foregroundColor(.primary)
                    .bold()
                Text("\(sensor.value) \(sensor.unit)")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .bold()
            }
            .padding()
        }
    }
}

struct Widget_Previews: PreviewProvider {
    static var previews: some View {
        Widget(sensor: .constant(Sensor.sampleHumidity))
    }
}
