import UIKit
import CoreLocation


class ViewController: UIViewController, CLLocationManagerDelegate {

    //MARK: - IBOutlet
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var currentTemperatureView: UIView!
    @IBOutlet weak var hourTemperatureView: UIView!
    @IBOutlet weak var currentMinMaxTempView: UIView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var topScrollView: UIScrollView!
    @IBOutlet weak var bottomScrollView: UIScrollView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var timezoneLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var currentDateLabel: UILabel!
    @IBOutlet weak var maxTemperatureLabel: UILabel!
    @IBOutlet weak var minTemperatureLabel: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var uviLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    
    
    
    //MARK: - var
    var hourlyIconImages: [UIImage] = []
    var dailyIconImages: [UIImage] = []
    var minMaxTemperature: Daily?
    var weatherData: WeatherData?
  
    //MARK: - let
    private let locationManager = CLLocationManager()
    
    
    
    //MARK: - Lifecycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.location()
        self.hourTemperatureViewConfig()
        self.addCurrentDate()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateWeatherAfterLaunch), name: Notification.Name.updateWeather, object: nil)
        
    }
    
    //MARK: - Flow functions
    private func hourTemperatureViewConfig() {
        self.hourTemperatureView.layer.borderWidth = 0.5
        self.hourTemperatureView.layer.borderColor = #colorLiteral(red: 0.8156862745, green: 0.8156862745, blue: 0.8156862745, alpha: 1)
        
    }
    
    private func getCurrentWeather() {

        self.maxTemperatureLabel.text = "\(Int(self.minMaxTemperature?.temp.max ?? Double()))º"
        self.minTemperatureLabel.text = "\(Int(self.minMaxTemperature?.temp.min ?? Double()))º"
        
        if let temp = self.weatherData?.current.temp {
            self.currentTemperatureLabel.text = "\(Int(temp))º"
        }
        
        if let description = self.weatherData?.current.weather?.first?.description {
            self.weatherDescriptionLabel.text = "\(description.capitalizingFirstLetter())"
        }
        
        self.timezoneLabel.text = self.weatherData?.timezone
    }
    
    private func getHourlyIcons() {
        guard let iconsArray = self.weatherData?.hourly else {  return }
        for element in iconsArray {
            for item in element.weather {
                self.hourlyIconImages.append(UIImage(named: item.icon) ?? UIImage())
            }
        }
    }
    
    private func getDailyIcons() {
        guard let iconsArray = self.weatherData?.daily else { return }
        for element in iconsArray {
            for item in element.weather {
                self.dailyIconImages.append(UIImage(named: item.icon) ?? UIImage())
            }
        }
    }
    
    private func location() {
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        manager.stopUpdatingLocation()
        
        NetworkService.shared.getRequest(lat: location.latitude, lon: location.longitude) { [weak self] (data) in
            self?.weatherData = data
            self?.collectionView.reloadData()
            self?.tableView.reloadData()
            self?.getCurrentWeather()
            self?.getHourlyIcons()
            self?.getDailyIcons()
            self?.addOtherWeatherData()
            self?.loadingView.isHidden = true
            
        }
    }
    
    func collectionViewConfig(_ cell: CustomCollectionViewCell, _ indexPath: IndexPath) {
        let temp = self.weatherData?.hourly[indexPath.item]
        
        if let weatherTemp = temp?.temp {
            cell.temperatureLabel.text = "\(Int(weatherTemp))º"
        }
        
        cell.weatherIcon.image = self.hourlyIconImages[indexPath.item]
        
        if indexPath.item == 0 {
            cell.timeLabel.text = "Now"
        } else {
            cell.timeLabel.text = self.addHourlyDate(date: temp?.dt ?? Int())
        }
    }
    
    private func addHourlyDate(date: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(date))
        let formatter = DateFormatter()
        formatter.dateFormat = "HH a"
        let hourDate = formatter.string(from: date)
        
        return hourDate
    }
    
    func tableViewConfig(_ cell: CustomTableViewCell, _ indexPath: IndexPath) {
        let temp = self.weatherData?.daily[indexPath.row]
        
        if let weatherTemp = temp?.temp {
            cell.dayTemperature.text = "\(Int(weatherTemp.day))º"
            cell.nightTemperature.text = "\(Int(weatherTemp.night))º"
        }
        
        cell.weatherIcon.image = self.dailyIconImages[indexPath.row]
        cell.textLabel?.text = self.addDailyDate(date: temp?.dt ?? Int())
        cell.textLabel?.textColor = .white
    }
    
    private func addDailyDate(date: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(date))
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        let dailyDate = formatter.string(from: date).capitalized
        
        return dailyDate
    }
    
    private func addCurrentDate() {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        let currentDate = formatter.string(from: date).capitalized
        self.currentDateLabel.text = currentDate
        
    }
    
    private func addOtherWeatherData() {
        let temp = self.weatherData?.current
        
        self.sunriseLabel.text = "\(self.getSunriseAndSunset(temp?.sunrise ?? Int()))"
        self.sunsetLabel.text = "\(self.getSunriseAndSunset(temp?.sunset ?? Int()))"
        
        self.humidityLabel.text = "\(Int(temp?.humidity ?? Double()))%"
        self.feelsLikeLabel.text = "\(Int(temp?.feelslike ?? Double()))º"
        self.uviLabel.text = "\(Int(temp?.uvi ?? Double()))"
        self.pressureLabel.text = "\(temp?.pressure ?? Int())hPa"
    }
    
    private func getSunriseAndSunset(_ date: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(date))
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let sunriseDate = formatter.string(from: date)

        return sunriseDate
    }
    
    @objc private func updateWeatherAfterLaunch() {
        self.location()
    }
}

