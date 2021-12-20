import SwiftUI

struct TeomeApp: View {
    @ObservedObject var ssidViewModel = SSIDViewModel()
    @ObservedObject var sensorViewModel = SensorViewModel()
    
    var body: some View {
        if ssidViewModel.deviceIP != nil, !sensorViewModel.sensors.isEmpty {
            SensorList(ssidViewModel: ssidViewModel, sensorViewModel: sensorViewModel)
        } else {
            NavigationView {
                PairDevice(ssidViewModel: ssidViewModel, sensorViewModel: sensorViewModel)
            }
        }
    }
}
