/*import Foundation
import NetworkExtension
import WiFiQRCodeKit

class HotspotConfiguration {
    
    private let hotspotConfigurationManager = NEHotspotConfigurationManager.shared
    private let distributionServer = SwifterMobileConfigDistributionServer(listeningOn: 8989)
    private let installer: MobileConfig.Installer
    private let state: MobileConfig.DistributionServerState
    private var installationResult: MobileConfig.Installer.InstallationResult? {
        didSet {
            if installationResult == .confirming {
                self.connect()
            }
        }
    }
    private let code: String
    
    init(code: String) {
        self.code = code
        installer = MobileConfig.Installer(distributingBy: distributionServer)
        state = distributionServer.start()
    }

    // Install the Wi-Fi settings.
    func install() {
        switch WiFiQRCodeKit.parse(text: code) {
        case .success(let wiFiQRCode):
            let mobileConfig = MobileConfig.from(
                wiFiQRCode: wiFiQRCode,
                organization: .init(organizationName: "Fedutia"),
                identifier: .init(identifier: "fr.fedutia.Teome"),
                description: "Connect tot the device",
                displayName: .init(displayName: "Teome"),
                consentText: .init(consentTextsForEachLanguages: [.default: "Would you join the Wi-Fi network that manged by Fedutia?"])
            )
            
            // You can modify other items such as the expiration option of the configuration profile.
            // Configurable items are listed on "Configuration Profile Reference".
            // See https://developer.apple.com/library/content/featuredarticles/iPhoneConfigurationProfileRef/
            mobileConfig
            installationResult = self.installer.install(mobileConfig: mobileConfig)
            
        case .failed(because: let reason):
            print(reason)
        }
    }
    
    func connect() {
        guard let data = code.data(using: .utf8),
              let dict = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : Any],
              let ssid = dict["S"] as? String,
              let pwd = dict["P"] as? String,
              let type = dict["T"] as? String else {
                  print("Error scanning code")
                  print(code)
                  return
              }

        let configuration = NEHotspotConfiguration.init(ssid: ssid, passphrase: pwd, isWEP: type == "WEP")

        configuration.joinOnce = true
        hotspotConfigurationManager.apply(configuration) { error in
            if let error = error {
                print("Error applying configuration")
                print(error)
                return
            }
            print("Success applying configuration")
        }
    }
}
*/
