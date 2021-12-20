import SwiftUI

struct WidgetDetails: View {
    @Binding var sensor: Sensor
    
    var body: some View {
        VStack {

        }        
    }
}

struct WidgetDetails_Previews: PreviewProvider {
    static var previews: some View {
        WidgetDetails(sensor: .constant(SensorType.humidity.sample))
    }
}
