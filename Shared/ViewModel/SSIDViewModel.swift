import Foundation
import SystemConfiguration.CaptiveNetwork
import Network
import SwiftUI

class SSIDViewModel: ObservableObject {
    @Published var ssid: String?
    @Published var loading: String?
    @Published var isError = false
    @Published var locationAllowed = false
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
        LocationPermissionAsker().askIfNeeded { status in
            let allowed = status == .authorizedAlways || status == .authorizedWhenInUse
            self.locationAllowed = allowed
            self.monitor.pathUpdateHandler = { _ in
                DispatchQueue.main.async {
                    self.refreshCurrentSSID()
                }
            }
            self.monitor.start(queue: self.queue)
            
            if !allowed {
                print("Please allow location")
            }
        }
    }
    
    private func refreshCurrentSSID() {
        self.loading = "Recherche du point d'accès"
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
        self.loading = "Communication avec l'appareil"
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
        self.loading = "Recherche des points d'accès"
        deviceCom.query(method: .LIST) {
            guard let sssids = $0 as? [String] else { return }
            DispatchQueue.main.async {
                self.deviceReachableSSIDs = sssids.sorted()
                self.loading = nil
            }
        }
    }
    
    func setDeviceCurrentSSID(_ ssid: String, _ pwd: String) {
        self.loading = "Envoi des identifiants WiFi"
        deviceCom.query(method: .POST, ["ssid": ssid, "pwd": pwd]) { deviceIP in
            DispatchQueue.main.async {
                guard let deviceIP = deviceIP as? IPv4Address else {
                    self.isError = true
                    self.loading = nil
                    return
                }
                self.deviceIP = deviceIP.rawValue
                self.loading = "Redémarrage de l'appareil"
            }
        }
    }
}
