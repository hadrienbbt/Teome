import Foundation
import SystemConfiguration.CaptiveNetwork
import Network

class SSIDViewModel: ObservableObject {
    @Published var ssid: String?
    @Published var loading = false
    @Published var connecting = false
    @Published var locationAllowed = false
    @Published var deviceCurrentSSID: String?
    @Published var deviceReachableSSIDs = [String]()
    
    private let deviceCom = DeviceCom()
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "Monitor")
    
    // TODO: Improve this
    var isConnectedToDevice: Bool {
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
    
    func refreshCurrentSSID() {
        self.loading = true
        guard let interfaceNames = CNCopySupportedInterfaces() as? [String] else {
            loading = false
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
            fetchDeviceReachableSSIDs()
        } else {
            self.loading = false
        }
    }
    
    func setDeviceCurrentSSID(ssid: String, pwd: String) {
        self.connecting = true
        deviceCom.query(method: "POST", ["ssid": ssid, "pwd": pwd]) { _ in
            DispatchQueue.main.async {
                self.connecting = false
            }
        }
    }
    
    func fetchDeviceReachableSSIDs() {
        self.loading = true
        deviceCom.query(method: "LIST") {
            guard let sssids = $0 as? [String] else { return }
            DispatchQueue.main.async {
                self.deviceReachableSSIDs = sssids.sorted()
                self.loading = false
            }
        }
    }
    
    func fetchDeviceCurrentSSID() {
        self.loading = true
        deviceCom.query(method: "GET") { ssid in
            DispatchQueue.main.async {
                self.loading = false
                guard let sssid = ssid as? String else { return }
                self.deviceCurrentSSID = sssid
            }
        }
    }
}
