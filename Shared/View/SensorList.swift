import SwiftUI

struct SensorList: View {
    @ObservedObject var ssidViewModel: SSIDViewModel
    @ObservedObject var sensorViewModel: SensorViewModel
    @State private var selectedId: String?
    @State private var deviceId: String? = ValueStore().deviceId
    
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
            if let updatedAt = sensorViewModel.updatedAt {
                Text(updatedAt.timeAgo)
            }
            Spacer()
        }
        .padding(.horizontal)
        .navigationBarTitle("Capteurs")
        .if(deviceId != nil) { view in
            view.toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Dissocier", action: {
                        self.sensorViewModel.listener?.remove()
                        self.sensorViewModel.sensors.removeAll()
                        self.ssidViewModel.unpairDevice(deviceId: deviceId!)
                    })
                }
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
