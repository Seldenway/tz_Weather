import Foundation
import UIKit


struct WeatherData: Decodable {
    let lat: Double
    let lon: Double
    let timezone: String
    let current: Current
    let hourly: [Hourly]
    var daily: [Daily]
    
}


struct Hourly: Decodable {
    let dt: Int
    let temp: Double
    let weather: [HourlyWeather]
}

struct HourlyWeather: Decodable {
    let icon: String
}



struct Current: Decodable {
    let dt: Int?
    let sunrise: Int?
    let sunset: Int?
    let temp: Double?
    let feelslike: Double?
    let pressure: Int?
    let humidity: Double?
    let uvi: Double?
    let weather: [CurrentWeather]?
    
    enum CodingKeys: String, CodingKey {
        case dt
        case sunrise
        case sunset
        case temp
        case feelslike = "feels_like"
        case pressure
        case humidity
        case uvi
        case weather
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.dt = try? container.decode(Int.self, forKey: .dt)
        self.sunrise = try? container.decode(Int.self, forKey: .sunrise)
        self.sunset = try? container.decode(Int.self, forKey: .sunset)
        self.temp = try? container.decode(Double.self, forKey: .temp)
        self.feelslike = try? container.decode(Double.self, forKey: .feelslike)
        self.pressure = try? container.decode(Int.self, forKey: .pressure)
        self.humidity = try? container.decode(Double.self, forKey: .humidity)
        self.uvi = try? container.decode(Double.self, forKey: .uvi)
        self.weather = try? container.decode([CurrentWeather].self, forKey: .weather)
    }
    
}

struct CurrentWeather: Decodable {
    let description: String
    let icon: String
}



struct Daily: Decodable {
    let dt: Int
    let temp: DailyTemp
    let weather: [DailyWeather]

}

struct DailyTemp: Decodable {
    let min: Double
    let max: Double
    let day: Double
    let night: Double
}

struct DailyWeather: Decodable {
    let icon: String
}



