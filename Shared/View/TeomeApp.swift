import SwiftUI

struct TeomeApp: View {
    @ObservedObject var ssidViewModel = SSIDViewModel()
    @ObservedObject var sensorViewModel = SensorViewModel()
    
    var body: some View {
        NavigationView {
            if ssidViewModel.deviceIP != nil, !sensorViewModel.sensors.isEmpty {
                SensorList(ssidViewModel: ssidViewModel, sensorViewModel: sensorViewModel)
            } else {
                PairDevice(ssidViewModel: ssidViewModel, sensorViewModel: sensorViewModel)
            }
        }
    }
}
