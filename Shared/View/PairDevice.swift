import Foundation
import SwiftUI
import CodeScanner

struct PairDevice: View {
    @ObservedObject var ssidViewModel: SSIDViewModel
    @ObservedObject var sensorViewModel: SensorViewModel
    @State private var isShowingScanner = false
    
    private var axis: Axis.Set {
        return ssidViewModel.isConnectedToDevice && ssidViewModel.deviceReachableSSIDs.isEmpty ? [] : .vertical
    }
    
    var body: some View {
        ScrollView(axis, showsIndicators: false)  {
            VStack {
                if ssidViewModel.deviceIP == nil {
                    if !ssidViewModel.isConnectedToDevice {
                        Text("Allumez l'appareil et connectez-vous en scannant le code QR")
                            .font(.headline)
                            .multilineTextAlignment(.center)
                            .padding(.top)
                    }
                    NetworkStatus(ssid: $ssidViewModel.ssid)
                    if ssidViewModel.isConnectedToDevice {
                        Divider().padding(.bottom)
                        SSIDList(viewModel: ssidViewModel)
                    }
                } else {
                    Text("L'appareil est jumelé.")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .padding(.top)
                    NetworkStatus(ssid: $ssidViewModel.ssid)
                    if ssidViewModel.isConnectedToDevice, let loading = ssidViewModel.loading {
                        CenteredProgressView(title: loading)
                    } else if let loading = sensorViewModel.loading {
                        CenteredProgressView(title: loading)
                    } else if ssidViewModel.ssid != nil {
                        CenteredProgressView().onAppear(perform: sensorViewModel.listenSensors)
                    } else {
                        CenteredProgressView(title: "Reconnecter l'internet")
                    }
                }
            }
            .padding(.horizontal)
        }
        // TODO: Make this work
        // .withBackgoundGradient()
        .navigationBarTitle("Teome")
        .if(ssidViewModel.isConnectedToDevice) { view in
            view.toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Refresh", action: ssidViewModel.fetchDeviceReachableSSIDs)
                        .disabled(ssidViewModel.loading != nil)
                }
            }
        }
    }
}

struct NetworkStatus: View {
    @Binding var ssid: String?
    
    var body: some View {
        HStack(spacing: 10) {
            if let ssid = ssid {
                Image(systemName: "wifi")
                    .frame(width: 30, height: 30)
                Text("Connected to \(ssid)")
                    .font(.subheadline)
            } else {
                Image(systemName: "wifi.slash")
                    .frame(width: 50, height: 50)
                Text("Not connected")
                    .font(.subheadline)
            }
        }
    }
}
