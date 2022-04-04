import Foundation
import SystemConfiguration.CaptiveNetwork
import Network
import SwiftUI
import Firebase
import FirebaseFirestore

enum SSIDLoadingState: String {
    case refreshCurrentSSID = "Recherche du point d'accès"
    case getDeviceSSID = "Communication avec l'appareil"
    case fetchDeviceReachableSSIDs = "Recherche des points d'accès"
    case setDeviceCurrentSSID = "Envoi des identifiants WiFi"
    case unpairDevice = "Dissociation en cours"
    case pressReset = "Appuyez sur le bouton RESET"
    case rebootingDevice = "Redémarrage de l'appareil"
}

class SSIDViewModel: ObservableObject {
    @Published var ssid: String?
    @Published var loading: SSIDLoadingState?
    @Published var isError = false
    @Published var deviceSSID: String? = ValueStore().deviceSSID {
        didSet {
            ValueStore().deviceSSID = deviceSSID
        }
    }
    @Published var deviceIP: Data? = ValueStore().deviceIP {
        didSet {
            ValueStore().deviceIP = deviceIP
        }
    }
    @Published var deviceReachableSSIDs = [String]()
    
    private let deviceCom = DeviceCom()
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "Monitor")
    
    // TODO: Improve this
    var isConnectedToDevice: Bool {
        // return ssid == deviceSSID
        guard let ssid = ssid else { return false }
        return ssid.contains("Teome")
    }
    
    init() {
        self.monitor.pathUpdateHandler = { _ in
            DispatchQueue.main.async {
                self.refreshCurrentSSID()
            }
        }
        self.monitor.start(queue: self.queue)
    }
    
    private func refreshCurrentSSID() {
        self.loading = SSIDLoadingState.refreshCurrentSSID
        guard let interfaceNames = CNCopySupportedInterfaces() as? [String] else {
            loading = nil
            return
        }
        let ssids: [String] = interfaceNames.compactMap { name in
            guard let info = CNCopyCurrentNetworkInfo(name as CFString) as? [String:AnyObject],
                  let ssid = info[kCNNetworkInfoKeySSID as String] as? String else {
                      return nil
                  }
            return ssid
        }
        self.ssid = ssids.first
        if isConnectedToDevice {
            deviceIP = nil
            self.getDeviceSSID()
        } else {
            self.loading = nil
        }
    }
    
    func getDeviceSSID() {
        self.loading = SSIDLoadingState.getDeviceSSID
        deviceCom.query(method: .GET) {
            guard let sssid = $0 as? String else { return }
            DispatchQueue.main.async {
                self.deviceSSID = sssid
                if self.deviceReachableSSIDs.isEmpty {
                    self.fetchDeviceReachableSSIDs()
                } else {
                    self.loading = nil
                }
            }
        }
    }
    
    func fetchDeviceReachableSSIDs() {
        self.loading = SSIDLoadingState.fetchDeviceReachableSSIDs
        deviceCom.query(method: .LIST) {
            guard let sssids = $0 as? [String] else { return }
            DispatchQueue.main.async {
                self.deviceReachableSSIDs = sssids
                self.loading = nil
            }
        }
    }
    
    func setDeviceCurrentSSID(_ ssid: String, _ pwd: String) {
        self.loading = SSIDLoadingState.setDeviceCurrentSSID
        deviceCom.query(method: .POST, ["ssid": ssid, "pwd": pwd]) { deviceIP in
            DispatchQueue.main.async {
                guard let deviceIP = deviceIP as? IPv4Address else {
                    self.isError = true
                    self.loading = nil
                    return
                }
                self.deviceIP = deviceIP.rawValue
                self.loading = SSIDLoadingState.rebootingDevice
                NotificationManager().configure()
            }
        }
    }
    
    func unpairDevice(deviceId: String) {
        self.loading = SSIDLoadingState.unpairDevice
        // Stub
        Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { _ in
            self.loading = SSIDLoadingState.pressReset
            Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { _ in
                self.deviceIP = nil
            }

        }
    }
}
