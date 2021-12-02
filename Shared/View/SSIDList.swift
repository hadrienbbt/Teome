import SwiftUI

struct SSIDList: View {
    @ObservedObject var viewModel: SSIDViewModel
    
    @State private var selected: String?
    @State private var password = ""
    
    func isSelected(_ ssid: String) -> Binding<Bool> {
        return Binding(
            get: { ssid == selected },
            set: { selected = $0 ? ssid : nil }
        )
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Veuillez sélectionner votre réseau WiFi")
                    .font(.headline)
                Spacer()
            }
            if let loading = viewModel.loading {
                if let ssid = selected {
                    SSIDRow(ssid: ssid, connect: { },
                            loading: loading,
                            password: $password,
                            isSelected: isSelected(ssid)
                    ).padding(.vertical)
                } else {
                    CenteredProgressView(title: loading.rawValue)
                }
            } else {
                if viewModel.deviceReachableSSIDs.isEmpty {
                    Text("Aucun réseau trouvé").padding(.top)
                } else {
                    ForEach(viewModel.deviceReachableSSIDs, id: \.self) { ssid in
                        SSIDRow(
                            ssid: ssid,
                            connect: { viewModel.setDeviceCurrentSSID(ssid, password) },
                            loading: viewModel.loading,
                            password: $password,
                            isSelected: isSelected(ssid)
                        ).padding(.bottom)
                    }
                }
            }
        }
        .alert("Mot de passe invalide", isPresented: $viewModel.isError) {
            Button("OK", role: .cancel) { }
        }
    }
}

struct SSIDRow: View {
    let ssid: String
    let connect: () -> Void
    let loading: SSIDLoadingState?
    
    @Binding var password: String
    @Binding var isSelected: Bool
    
    @State var passwordVisible = false

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            if isSelected {
                Divider()
            }
            Button(ssid, action: {
                isSelected.toggle()
            }).disabled(loading != nil)
            if isSelected {
                HStack {
                    if passwordVisible, loading == nil {
                        TextField("Mot de passe WiFi", text: $password)
                    } else {
                        SecureField("Mot de passe WiFi", text: $password)
                    }
                    Button(action: { self.passwordVisible.toggle() }) {
                        Image(systemName: self.passwordVisible ? "eye.slash" : "eye")
                    }.disabled(loading != nil)
                }
                if let loading = loading {
                    CenteredProgressView(title: loading.rawValue)
                } else {
                    Button(action: { self.connect() }) {
                        Text("Connecter").font(.headline)
                    }
                }
                Divider()
            }
        }
    }
}

struct CenteredProgressView: View {
    var title: String = "Chargement"
    
    var body: some View {
        HStack {
            Spacer()
            if let title = title {
                ProgressView(title)
                    .progressViewStyle(.circular)
                    .padding(.top)
            } else {
                ProgressView()
                    .progressViewStyle(.circular)
                    .padding(.top)
            }
            Spacer()
        }
    }
}
