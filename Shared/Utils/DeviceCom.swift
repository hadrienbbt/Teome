import Foundation
import UIKit

class DeviceCom {
    
    func isReachable(_ completion: @escaping (Bool) -> Void) {
        
    }
    
    func query(method: String, _ params: [String: Any]? = nil, _ completion: @escaping (Any?) -> Void) {
        var request = URLRequest(url: URL(string: "http://192.168.2.1/ap")!)
        request.httpMethod = method
        if method == "POST", let params = params {
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
            print(string)
            if method == "LIST" {
                completion(string.components(separatedBy: "\n"))
            } else {
                completion(string)
            }
        }
        task.resume()
    }
}
