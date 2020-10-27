import Foundation
import UIKit


class NetworkService {
    static let shared = NetworkService()
    private init() {}
    
    var weatherData: WeatherData?
    
    func getRequest(lat: Double?, lon: Double?, comletion: @escaping () -> ()) {
        self.sendRequest(latitude: lat, longitude: lon) { [weak self] (data) in
            do {
                let json = try JSONDecoder().decode(WeatherData.self, from: data)
                self?.weatherData = json
                DispatchQueue.main.async {
                    comletion()
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

