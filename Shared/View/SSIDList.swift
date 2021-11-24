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
            if viewModel.loading {
                CenteredProgressView()
            } else if viewModel.deviceReachableSSIDs.isEmpty {
                Text("Aucun réseau trouvé")
                    .padding(.top)
            } else if viewModel.connecting, let ssid = selected {
                SSIDRow(ssid: ssid, connect: { },
                    connecting: viewModel.connecting,
                    password: $password,
                    isSelected: isSelected(ssid)
                )
                .padding(.vertical)
            } else {
                ForEach(viewModel.deviceReachableSSIDs, id: \.self) { ssid in
                    SSIDRow(
                        ssid: ssid,
                        connect: { viewModel.setDeviceCurrentSSID(ssid: ssid, pwd: password) },
                        connecting: viewModel.connecting,
                        password: $password,
                        isSelected: isSelected(ssid)
                    )
                    .padding(.bottom)
                }
            }
        }
    }
}

struct SSIDRow: View {
    let ssid: String
    let connect: () -> Void
    let connecting: Bool
    
    @Binding var password: String
    @Binding var isSelected: Bool
    
    @State var passwordVisible = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            if isSelected {
                Divider()
            }
            Button(ssid, action: {
                if !connecting {
                    isSelected.toggle()
                }
            })
            if isSelected {
                HStack {
                    if passwordVisible {
                        TextField("Mot de passe WiFi", text: $password)
                    } else {
                        SecureField("Mot de passe WiFi", text: $password)
                    }
                    Button(action: { self.passwordVisible.toggle() }) {
                        Image(systemName: self.passwordVisible ? "eye.slash" : "eye")
                    }
                }
                if connecting {
                    CenteredProgressView(title: "Envoi des identifiants WiFi")
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
    var title: String?
    
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
