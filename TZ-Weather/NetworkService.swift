import Foundation
import UIKit


class NetworkService {
    static let shared = NetworkService()
    private init() {}
    
    
    func getRequest(lat: Double?, lon: Double?, comletion: @escaping (WeatherData) -> ()) {
        self.sendRequest(latitude: lat, longitude: lon) { (data) in
            do {
                let json = try JSONDecoder().decode(WeatherData.self, from: data)
                DispatchQueue.main.async {
                    comletion(json)
                }
            } catch let error {
                print(error.localizedDescription)
                
            }
        }
        
    }
    
    private func sendRequest(latitude: Double?, longitude: Double?, completion: @escaping (Data)->()) {
        guard let lat = latitude, let lon = longitude else { return }
        guard let url = URL(string: "\(Constants.baseURL)lat=\(lat)&lon=\(lon)\(Constants.endPoint)") else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error == nil, let data = data {
                completion(data)
            } else {
                print(error?.localizedDescription as Any)
            }
            
        }
        task.resume()
    }
}

