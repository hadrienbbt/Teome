import SwiftUI

struct SensorList: View {
    @ObservedObject var ssidViewModel: SSIDViewModel
    @ObservedObject var sensorViewModel: SensorViewModel
    @State private var selectedId: String?
    
    let columns = [
        GridItem(.adaptive(minimum: 140), spacing: 20)
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach($sensorViewModel.sensors) {
                    Widget(sensor: $0, selectedId: $selectedId)
                }
            }
            Spacer()
        }
        .padding(.horizontal)
        .withBackgoundGradient(alignment: .leading)
        .navigationBarTitle("Sensors")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Unpair", action: {
                    ssidViewModel.deviceIP = nil
                    sensorViewModel.sensors = []
                })
            }
        }
        .onAppear(perform: sensorViewModel.listenSensors)
    }
}

struct SensorList_Previews: PreviewProvider {
    static var previews: some View {
        SensorList(ssidViewModel: SSIDViewModel(), sensorViewModel: SensorViewModel())
    }
}
