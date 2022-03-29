import Foundation
import SwiftUI
import CodeScanner
import Network

struct PairDevice: View {
    @ObservedObject var ssidViewModel: SSIDViewModel
    @ObservedObject var sensorViewModel: SensorViewModel
    @State private var isShowingScanner = false
    @State private var scannedCode: String?

    private var axis: Axis.Set {
        return ssidViewModel.isConnectedToDevice && ssidViewModel.deviceReachableSSIDs.isEmpty ? [] : .vertical
    }
    
    private var toolbarItem: some ToolbarContent {        
        if ssidViewModel.isConnectedToDevice {
            return ToolbarItem(placement: .navigationBarTrailing) {
                Button("Refresh", action: ssidViewModel.fetchDeviceReachableSSIDs)
                    .disabled(ssidViewModel.loading != nil) as! Button<Text>
            }
        } else {
            return ToolbarItem(placement: .navigationBarTrailing) {
                Button("Scan", action: {
                    isShowingScanner = true
                })
            }
        }
    }
    
    private var QRDCodeSheet: CodeScannerView {
        return CodeScannerView(codeTypes: [.qr]) { response in
            if case let .success(result) = response {
                guard let ssid = result
                    .components(separatedBy: ";")
                    .first?
                    .components(separatedBy: ":")
                    .last,
                      let ip = IPv4Address("192.168.1.1") else {
                    print("Invalid QRCode")
                    return
                }
                scannedCode = result
                isShowingScanner = false
                ssidViewModel.deviceSSID = ssid
                ssidViewModel.deviceIP = ip.rawValue
                sensorViewModel.listenSensors()
            }
        }

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
                        SSIDList(viewModel: ssidViewModel)
                    }
                } else {
                    Text("L'appareil est jumelé.")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .padding(.top)
                    NetworkStatus(ssid: $ssidViewModel.ssid)
                    if let loading = ssidViewModel.loading {
                        CenteredProgressView(title: loading.rawValue)
                    } else if let loading = sensorViewModel.loading {
                        CenteredProgressView(title: loading.rawValue)
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
        .toolbar { toolbarItem }
        .sheet(isPresented: $isShowingScanner) { QRDCodeSheet }
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
