import CoreLocation

class LocationPermissionAsker: NSObject, CLLocationManagerDelegate {
        
    private static var manager: CLLocationManager?
    private var completion: ((_ status: CLAuthorizationStatus) -> Void)?
    
    func askIfNeeded(completion: @escaping (CLAuthorizationStatus) -> Void) {
        LocationPermissionAsker.manager = CLLocationManager()
        LocationPermissionAsker.manager!.delegate = self
        
        self.completion = completion
        
        let status = CLLocationManager.authorizationStatus()
        if status == .notDetermined {
            LocationPermissionAsker.manager!.requestWhenInUseAuthorization()
        } else {
            finish(status)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != .notDetermined {
            finish(status)
        }
    }
    
    private func finish(_ status: CLAuthorizationStatus) {
        DispatchQueue.main.async {
            self.completion?(status)
            self.completion = nil
        }
        LocationPermissionAsker.manager = nil
    }
    
}
