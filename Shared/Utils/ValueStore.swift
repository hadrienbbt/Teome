import Foundation

class ValueStore {
    
    let suiteName = "group.fr.fedutia.Teome"
    
    var sensors: [Sensor] {
        get {
            if let data = read("sensors") as? Data,
                let sensors = try? JSONDecoder().decode([Sensor].self, from: data) {
                return sensors
            }
            return []
        }
        set {
            if let data = try? JSONEncoder().encode(newValue) {
                write("sensors", data)
            }
        }
    }

    private func read(_ key: String) -> Any? {
        guard let userDefaults = UserDefaults(suiteName: suiteName) else {
            print("❌ App group not configured for target")
            return UserDefaults.standard.object(forKey: key)
        }
        return userDefaults.object(forKey: key)
    }
    
    private func write(_ key: String, _ newValue: Any?) {
        guard let userDefaults = UserDefaults(suiteName: suiteName) else {
            print("❌ App group not configured for target")
            return UserDefaults.standard.set(newValue, forKey: key)
        }
        userDefaults.set(newValue, forKey: key)
    }
}
