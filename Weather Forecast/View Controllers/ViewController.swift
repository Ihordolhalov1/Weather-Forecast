//
//  File.swift
//  Weather Forecast
//
//  Created by Ihor Dolhalov on 09.04.2023.
//  Copyright © 2023 Ihor Dolhalov. All rights reserved.
//÷

import UIKit
import CoreLocation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var feelsLikeTemperatureLabel: UILabel!
    
    @IBOutlet weak var weatherTable: weatherTable!
    
    var networkWeatherManager = NetworkWeatherManager()
    
    var dateString: [String] = []
    var conditionCodeForecast: [Int] = []
    var temperatureForecast: [Double] = []
    var pod: [String] = []
    var shift: Int  = 0
    
    
    lazy var locationManager: CLLocationManager = {
        let lm = CLLocationManager()
        lm.delegate = self
        lm.desiredAccuracy = kCLLocationAccuracyKilometer
        lm.requestWhenInUseAuthorization()
        return lm
    }()
    
    @IBAction func searchPressed(_ sender: UIButton) {
        self.presentSearchAlertController(withTitle: "Enter city name", message: nil, style: .alert) { [unowned self] city in
            self.networkWeatherManager.fetchCurrentWeather(forRequestType: .cityName(city: city))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherTable.dataSource = self
        networkWeatherManager.onCompletion = { [weak self] currentWeather in
            guard let self = self else { return }
            self.updateInterfaceWith(weather: currentWeather)
        }
        

            if CLLocationManager.locationServicesEnabled() {
                if #available(iOS 14.0, *) {
                    switch self.locationManager.authorizationStatus {
                    case .notDetermined, .restricted, .denied:
                        print("No access")
                    case .authorizedAlways, .authorizedWhenInUse:
                        print("Access")
                        self.locationManager.requestLocation()
                    @unknown default:
                        break
                    }
                } else {
                    //якщо версія нижще 14
                    self.locationManager.requestLocation()
                }
            }
            else {
                print("Location services are not enabled")
            }
        
        
    
        
    }
    
    func updateInterfaceWith(weather: WeatherForecast) {
        DispatchQueue.main.async {
            self.cityLabel.text = weather.cityName
            self.temperatureLabel.text = weather.temperatureString
            self.feelsLikeTemperatureLabel.text = weather.feelsLikeTemperatureString
            self.weatherIconImageView.image = UIImage(systemName: weather.systemDayIconNameString)
            
            self.dateString = weather.date
            self.conditionCodeForecast = weather.conditionCodeForecast
            self.temperatureForecast = weather.temperatureForecast
            self.pod = weather.pod
            self.shift = weather.timezone
            self.weatherTable.reloadData()
        
        }
    }
}


// MARK: - CLLocationManagerDelegate

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        print("відпрацював метод locationManager по координатам")
        debugPrint(latitude, longitude)
        networkWeatherManager.fetchCurrentWeather(forRequestType: .coordinate(latitude: latitude, longitude: longitude))
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countOfDate
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "weatherTableViewCell") as? weatherTableViewCell {
            //Temperature
            if temperatureForecast == [] {cell.temperatureLabel.text = "no temp"} else {
                print("I will fulfil temperature now")
                var temperatureString: String {
                    return String(format: "%.1f", temperatureForecast[indexPath.row])
                }
                cell.temperatureLabel.text = temperatureString + "ºC"
            }
            
            
        
        //ImageCloud
            if conditionCodeForecast == [] {print("масив картинок пустий")
            } else {
                print("I will fulfil picture now")
                var systemIconNameString: String {
                    switch conditionCodeForecast[indexPath.row] {
                    case 200...232: return "cloud.bolt.rain.fill"
                    case 300...321: return "cloud.drizzle.fill"
                    case 500...531: return "cloud.rain.fill"
                    case 600...622: return "cloud.snow.fill"
                    case 701...781: return "smoke.fill"
                    case 800: return "sun.min.fill"
                    case 801...804: return "cloud.fill"
                    default: return "nosign"
                    }
                }
                cell.cloudImage.image = UIImage(systemName: systemIconNameString)
                if pod[indexPath.row] == "n" {cell.cloudImage.tintColor = .darkGray
                } else {cell.cloudImage.tintColor = .blue }
            }
            
            //Date
            if dateString == [] {cell.dateLabel.text = "Do not have date"} else {
                print ("I will fulfil the table now with date")
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "en_US")
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                guard let date = dateFormatter.date(from: dateString[indexPath.row])
                else { print ("Не вдалося витягнути дату в формате date")
                    return weatherTableViewCell()}
                print("конвертнув дату")
                print (date)
                var dateComponents = DateComponents() //визначаю скільки секунд треба додати до часу виходячи з часового пояса
                dateComponents.second = shift
                print ("shift is \(shift)")
                let calendar = Calendar.current
                
                guard let modifiedDate = calendar.date(byAdding: dateComponents, to: date) // додаю секунди часового пояса
                else {
                    print("Не вдалося додати секунди shift")
                   return weatherTableViewCell()}
          
                print (modifiedDate)
                
                let today = calendar.startOfDay(for: Date())
                let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)!
                let isToday = calendar.isDate(modifiedDate, inSameDayAs: today)
                let isTomorrow = calendar.isDate(modifiedDate, inSameDayAs: tomorrow)
                if isToday {
                    dateFormatter.dateFormat = "'today' HH:mm"
                } else if isTomorrow {
                    dateFormatter.dateFormat = "'tomorrow' HH:mm"
                } else {
                    dateFormatter.dateFormat = "EEEE dd.MM HH:mm"
                }

                let formattedDate = dateFormatter.string(from: modifiedDate)
                cell.dateLabel.text = formattedDate
            }
            
            return cell
        } else {
            return weatherTableViewCell()
        }
    }
    
    
    
}
