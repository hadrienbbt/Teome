import SwiftUI

struct SensorList: View {
    @ObservedObject var ssidViewModel: SSIDViewModel
    @ObservedObject var sensorViewModel: SensorViewModel

    @State private var selected: Sensor?
    @State private var deviceId: String? = ValueStore().deviceId
    
    @Namespace private var widgetEffect
    
    let columns = [
        GridItem(.adaptive(minimum: 140), spacing: 20)
    ]
    
    func isSelected(_ sensor: Sensor) -> Binding<Bool> {
        return Binding(
            get: { sensor.id == selected?.id },
            set: { selected = $0 ? sensor : nil }
        )
    }
    
    var body: some View {
        ZStack {
            NavigationView {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach($sensorViewModel.sensors) { sensor in
                            Widget(sensor: sensor, isSelected: isSelected(sensor.wrappedValue))
                                .matchedGeometryEffect(id: sensor.id, in: widgetEffect)
                                .onTapGesture { selected = sensor.wrappedValue }
                        }
                    }
                    .padding()
                    if let updatedAt = sensorViewModel.updatedAt {
                        Text(updatedAt.timeAgo)
                    }
                }
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
            }
            if let selected = selected {
                ScrollView {
                    Widget(sensor: .constant(selected), isSelected: isSelected(selected))
                        .matchedGeometryEffect(id: selected.id, in: widgetEffect)
                        .frame(maxWidth: 400)
                        .padding(30)
                        .onTapGesture { }
                    Text("Some text content")
                    Spacer()
                }
                .onTapGesture { self.selected = nil }
                .frame(maxWidth: .infinity)
                .background(.ultraThinMaterial)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: selected?.id)
        .onAppear {
            sensorViewModel.listenSensors()
        }
    }
}

struct SensorList_Previews: PreviewProvider {
    static var previews: some View {
        SensorList(ssidViewModel: SSIDViewModel(), sensorViewModel: SensorViewModel())
    }
}
