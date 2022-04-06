import Foundation
import UIKit
import Network

enum Method: String {
    case GET
    case LIST
    case POST
}

class ServerCom {
    func getQRCode(_ deviceId: String, _ completion: @escaping (String?) -> Void) {
        guard let body = try? JSONEncoder().encode(["deviceId": deviceId]) else {
            completion(nil)
            return
        }
        var request = URLRequest(url: URL(string: "http://192.168.1.150:8000/qrcode")!)
        request.httpMethod = Method.POST.rawValue
        request.httpBody = body
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Client error")
                print(error.localizedDescription)
                completion(nil)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                      print("Server error")
                      print(response.debugDescription)
                      completion(nil)
                      return
                  }
            guard let mimeType = httpResponse.mimeType,
                  mimeType == "application/json",
                  let data = data,
                  let dict = try? JSONDecoder().decode([String: String].self, from: data),
                  let qrcode = dict["qrcode"] else { return }
            completion(qrcode)
        }
        task.resume()
    }
}

class DeviceCom {
    func query(method: Method, _ params: [String: Any]? = nil, _ completion: @escaping (Any?) -> Void) {
        var request = URLRequest(url: URL(string: "http://192.168.2.1/ssid")!)
        request.httpMethod = method.rawValue
        if method == .POST, let params = params {
            let body: String = params.reduce("", { (result, param) in
                let (key, value) = param
                return "\(result)\(key)=\(value);"
            })
            request.httpBody = body.data(using: .utf8)
        }
        request.setValue("text/plain", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Client error")
                print(error.localizedDescription)
                completion(nil)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                      print("Server error")
                      print(response.debugDescription)
                      completion(nil)
                      return
                  }
            guard let mimeType = httpResponse.mimeType,
                  mimeType == "text/plain",
                  let data = data,
                  let string = String(data: data, encoding: .utf8) else { return }
            if method == .GET {
                print("Found deviceID: \(string)")
                completion(string)
            } else if method == .LIST {
                let reachableSSIDS = string
                    .components(separatedBy: "\n")
                    .sorted()
                    .filter { $0 != "" }
                print(reachableSSIDS)
                completion(reachableSSIDS)
            } else {
                let components = string.components(separatedBy: "\n")
                guard components.count == 2,
                      let ip = components.first,
                      let error = components.last else {
                          print("Can't parse response")
                          print(components)
                          return
                      }
                guard let ipv4 = IPv4Address(ip) else {
                    print("Can't connect to SSID, \(error)")
                    completion(nil)
                    return
                }
                print(ipv4)
                completion(ipv4)
            }
        }
        task.resume()
    }
}
