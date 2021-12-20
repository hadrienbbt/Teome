import SwiftUI

struct Widget: View {
    @Binding var sensor: Sensor
    @Binding var isSelected: Bool
    
    @Namespace private var widgetEffect
    
    var image: some View {
        Image(sensor.image)
            .resizable()
            .frame(width: 40, height: 40)
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
            .padding()
            .foregroundColor(.tertiaryLabel)
            .onTapGesture { isSelected = false }
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(.secondarySystemBackground)
            if isSelected {
                VStack {
                    HStack {
                        image
                        VStack(alignment: .leading) {
                            title
                            value
                        }
                        Spacer()
                        close
                    }.padding()
                    Text("Chart").frame(height: 400)
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
