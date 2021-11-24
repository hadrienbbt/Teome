import Foundation
import SwiftUI
import CodeScanner

struct PairDevice: View {
    @ObservedObject private var viewModel = SSIDViewModel()
    @State private var isShowingScanner = false

    private var axis: Axis.Set {
        return viewModel.isConnectedToDevice && viewModel.deviceReachableSSIDs.isEmpty ? [] : .vertical
    }

    var body: some View {
        NavigationView {
            ScrollView(axis, showsIndicators: false)  {
                VStack {
                    if !viewModel.isConnectedToDevice {
                        Text("Allumez l'appareil et connectez-vous en scannant le code QR")
                            .font(.headline)
                            .multilineTextAlignment(.center)
                            .padding(.top)
                    }
                    NetworkStatus(ssid: $viewModel.ssid)
                    if viewModel.isConnectedToDevice {
                        Divider().padding(.bottom)
                        SSIDList(viewModel: viewModel)
                    }
                }
                .padding(.horizontal)
            }
            // TODO: Make this work
            // .withBackgoundGradient()
            .navigationBarTitle("Teome")
            .if(viewModel.isConnectedToDevice) { view in
                view.toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Refresh", action: viewModel.fetchDeviceReachableSSIDs)
                            .disabled(viewModel.loading || viewModel.connecting)
                    }
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
