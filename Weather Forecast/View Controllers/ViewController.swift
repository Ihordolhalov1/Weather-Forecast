//
//  File.swift
//  Weather Forecast
//
//  Created by Ihor Dolhalov on 09.04.2023.
//  Copyright © 2023 Ihor Dolhalov. All rights reserved.
//÷

import UIKit
import CoreLocation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    


    @IBOutlet weak var mainPhotoImage: UIImageView!
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var feelsLikeTemperatureLabel: UILabel!
    
    @IBOutlet weak var detailedView: UIView!
    
    @IBOutlet weak var cityView: UIView!
    
    @IBOutlet weak var settingsView: UIView!
  
    @IBOutlet weak var mainPhotoIcon: UIImageView!
    
    
    @IBOutlet weak var weatherTable: UITableView!
    
    @IBOutlet weak var detailedTempLabel: UILabel!
    @IBOutlet weak var detailedLikeTempLabel: UILabel!
    
    @IBOutlet weak var detailedWeatherDescriptionLabel: UILabel!
    @IBOutlet weak var detailedPressureLabel: UILabel!
    @IBOutlet weak var detailedHumidityLabel: UILabel!
    @IBOutlet weak var detailedCloudityLabel: UILabel!
    @IBOutlet weak var detailedProbabilityLabel: UILabel!
    @IBOutlet weak var detailedVisibilityLabel: UILabel!
    @IBOutlet weak var detailedWindSpeedLabel: UILabel!
    @IBOutlet weak var detailedWindDirectionLabel: UILabel!
    @IBOutlet weak var detailedWindGustLabel: UILabel!
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var populationLabel: UILabel!
    
    @IBOutlet weak var windDirection: UIImageView!
    
    
    var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var weatherTableViewHeightConstraint: NSLayoutConstraint!
    
    
    
    var networkWeatherManager = NetworkWeatherManager()
    
    var dateString: [String] = []
    var conditionCodeForecast: [Int] = []
    var temperatureForecast: [Double] = []
    var feelsLikeForecast: [Double] = []
    var weatherDescription: [String] = []
    var pressure: [Double] = []
    var humidity: [Double] = []
    var cloudiness: [Int] = []
    var pod: [String] = []
    var shift: Int  = 0
    var speed: [Double] = []
    var pop: [Int] = []
    var visibility: [Int] = []
    var deg: [Int] = []
    var windDirectionString: [String] = []
    var gust: [Double] = []
    
    var country:String = ""
    var population: Int  = 0
    var sunrise: Int = 0
    var sunset: Int = 0
    
    var isMainPhotoChosen = false
    
    
   

  
    
    lazy var locationManager: CLLocationManager = {
        let lm = CLLocationManager()
        lm.delegate = self
        lm.desiredAccuracy = kCLLocationAccuracyKilometer
        lm.requestWhenInUseAuthorization()
        return lm
    }()
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        detailedView.isHidden = true
        stackView.isHidden = false
    }
    @IBAction func searchPressed(_ sender: UIButton) {
        self.presentSearchAlertController(withTitle: "Enter city name", message: nil, style: .alert) { [unowned self] city in
            self.networkWeatherManager.fetchWeatherForecast(forRequestType: .cityName(city: city))
        }
    }
    
    @IBAction func geolocationButtonPressed(_ sender: Any) {
        locationManager.requestWhenInUseAuthorization()
       
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            if let coordinates = locationManager.location?.coordinate {
                let geocoder = CLGeocoder()
                let location = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
                let latitude = location.coordinate.latitude
                let longitude = location.coordinate.longitude
                print (latitude)
                print (longitude)
            //let locale = Locale(identifier: "en_GB")
                // Reverse geocode coordinates to get city name
                geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                    if let placemark = placemarks?.first {
                        if let city = placemark.locality {
                            // Update label text with city name
                            self.cityLabel.text = city
                            self.networkWeatherManager.fetchWeatherForecast(forRequestType: .coordinate(latitude: latitude, longitude: longitude))
                            self.networkWeatherManager.fetchCurrentWeather(forRequestType: .coordinate(latitude: latitude, longitude: longitude))

                        }
                    }
                }
            }
        }
    }
    
    
    @IBAction func informationButtonPressed(_ sender: Any) {
        detailedView.isHidden = true
        stackView.isHidden = true
        settingsView.isHidden = true
        cityView.isHidden = false
        cityNameLabel.text = cityLabel.text
        countryNameLabel.text = country
        populationLabel.text = "\(population)"
    }
    
    @IBAction func cityCloseButtonPressed(_ sender: Any) {
        cityView.isHidden = true
        stackView.isHidden = false
    }
    
    
    // зміна розміру висоти tableview від пальця
    @objc func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: view)
        
        if let view = gestureRecognizer.view {
            // Calculate the new constant for the height constraint
            var newHeight = heightConstraint.constant - translation.y
            
            // Update the height constraint based on the dragging motion
            
            if newHeight < 100 {
                newHeight = 100
            } else {
                if newHeight > 900
                { newHeight = 900 }
                else {
                   // nothing need to be changed
                }
            }
            heightConstraint.constant = newHeight
            weatherTableViewHeightConstraint = heightConstraint
            // Reset the translation
            gestureRecognizer.setTranslation(CGPoint.zero, in: view)
        }
    }

    
    @IBAction func settingButtonPressed(_ sender: Any) {
        cityView.isHidden = true
        detailedView.isHidden = true
        stackView.isHidden = false
        settingsView.isHidden = !settingsView.isHidden
        
    }
    
    // MARK: Choose main photo from the library
    
   

    
   
    
    func openPhotoGallery() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            present(imagePicker, animated: true, completion: nil)
        }
    } //функція вибора фото

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)

        if let selectedImage = info[.originalImage] as? UIImage {
            mainPhotoIcon.image = selectedImage
            mainPhotoImage.image = selectedImage
            
            guard let data = selectedImage.jpegData(compressionQuality: 1) else { return }
            let encoded = try! PropertyListEncoder().encode(data)
            UserDefaults.standard.set(encoded, forKey: "MainPhoto")
        }
    }

    

  
    
    
    @objc func MainPhotoIconImageTapped() {
           // Handle the tap on the UIImageView here
           print("Image tapped!")
        openPhotoGallery()

       }
    

    
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        settingsView.isHidden = true
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Detect that MainPhotoIconImage was tapped
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MainPhotoIconImageTapped))
                mainPhotoIcon.addGestureRecognizer(tapGestureRecognizer)
                mainPhotoIcon.isUserInteractionEnabled = true
        mainPhotoImage.isUserInteractionEnabled = true
        mainPhotoImage.addGestureRecognizer(tapGestureRecognizer)

        
        
       // чомусь повертає картинку на 90 градусів. Силомиць повертаю назад
     //   let rotationAngle: CGFloat = CGFloat.pi / 2 // 90 degrees in radians
     //   mainPhotoIcon.transform = CGAffineTransform(rotationAngle: rotationAngle)
        
        
        locationManager.delegate = self
        weatherTable.dataSource = self
        weatherTable.delegate = self
        stackView.isHidden = false
        
        heightConstraint = weatherTableViewHeightConstraint
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
            weatherTable.addGestureRecognizer(panGesture)
        
        //let randomNum = Int(arc4random_uniform(10)) + 1
       // let name = "\(randomNum).heic"
         let name = "emptyPhoto.png"
         mainPhotoImage.image = UIImage(named: name)
       // mainPhotoImage.image = UIImage(systemName: "person.crop.rectangle.fill")

            guard let data = UserDefaults.standard.data(forKey: "MainPhoto") else { return }
             let decoded = try! PropertyListDecoder().decode(Data.self, from: data)
        mainPhotoImage.image = UIImage(data: decoded)
    
        
        
        
        networkWeatherManager.onCompletionForecast = { [weak self] Weather in
           guard let self = self else { return }
           self.updateInterfaceWith(weather: Weather)
       }
        networkWeatherManager.onCompletionCurrent = { [weak self] Weather in
           guard let self = self else { return }
           self.updateInterfaceWith(weather: Weather)
       }
        
        

        locationManager.requestWhenInUseAuthorization()
        
            if CLLocationManager.locationServicesEnabled() {
                if #available(iOS 14.0, *) {
                    switch self.locationManager.authorizationStatus {
                    case .restricted, .denied:
                        print("RESTRICTED")
                    case .notDetermined, .authorizedAlways, .authorizedWhenInUse:
                        print("ACCESS")
                        self.locationManager.requestLocation()
                        networkWeatherManager.onCompletionForecast = { [weak self] currentWeather in
                            guard let self = self else { return }
                            self.updateInterfaceWith(weather: currentWeather)
                        }
                        
                    @unknown default:
                        print("UNKNOWN DEFAULT")
                        break
                    }
                } else {
                    //якщо версія нижще 14
                    print("VERSION LOW THAN 14")
                    self.locationManager.requestLocation()
                    networkWeatherManager.onCompletionForecast = { [weak self] currentWeather in
                        guard let self = self else { return }
                        self.updateInterfaceWith(weather: currentWeather)
                    }
                }
            }
            else {
                print("Location services are not enabled")
            }
        detailedView.layer.cornerRadius = 10
        detailedView.isHidden = true
        cityView.isHidden = true
        cityView.layer.cornerRadius = 10
        settingsView.isHidden = true
        settingsView.layer.cornerRadius = 10
        
    }
    
    func updateInterfaceWith(weather: CurrentWeather) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.feelsLikeTemperatureLabel.text = weather.feelsLikeTemperatureString
       
        }
    }
    
    func updateInterfaceWith(weather: WeatherForecast) {
        DispatchQueue.main.async {
            self.cityLabel.text = weather.cityName
     
            self.weatherIconImageView.image = UIImage(systemName: weather.systemDayIconNameString)
            
            self.dateString = weather.date
            self.conditionCodeForecast = weather.conditionCodeForecast
            self.temperatureForecast = weather.temperatureForecast
            self.pod = weather.pod
            self.shift = weather.timezone
            self.speed = weather.speed
            self.feelsLikeForecast = weather.feelsLikeForecast
            self.weatherDescription = weather.description
            self.humidity = weather.humidity
            self.pressure = weather.pressure
            self.cloudiness = weather.cloudiness
            self.pop = weather.pop
            self.visibility = weather.visibility
            
            self.deg = weather.deg
            self.windDirectionString = weather.windDirectionString
            self.gust = weather.gust
            self.country = weather.country
            self.population = weather.population
            
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
        networkWeatherManager.fetchWeatherForecast(forRequestType: .coordinate(latitude: latitude, longitude: longitude))
        networkWeatherManager.fetchCurrentWeather(forRequestType: .coordinate(latitude: latitude, longitude: longitude))
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
   
    // Implement the delegate method to handle authorization status changes
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            if status == .authorizedWhenInUse {
                self.locationManager.requestLocation()
                
                networkWeatherManager.onCompletionForecast = { [weak self] Weather in
                    guard let self = self else { return }
                    self.updateInterfaceWith(weather: Weather)
                }
                
                networkWeatherManager.onCompletionCurrent = { [weak self] Weather in
                   guard let self = self else { return }
                   self.updateInterfaceWith(weather: Weather)
               }
                
                
            }
        }
    
    
    
    
    // MARK: - TableView
    
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
            
            
        //WindSpeed
            if speed == [] {cell.windLabel.text = "Unknown location"} else {
                print ("I will fulfil the table now with wind speed")
                var speedString: String {
                    return String(format: "%.1f", speed[indexPath.row])
                }
                cell.windLabel.text = String(format: "%.1f", speed[indexPath.row]) + " m/s"
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
            if dateString == [] {cell.dateLabel.text = "Unknown location"} else {
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
                    dateFormatter.dateFormat = "'Today' HH:mm"
                } else if isTomorrow {
                    dateFormatter.dateFormat = "'Tomorrow' HH:mm"
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cityView.isHidden = true
        stackView.isHidden = true
        settingsView.isHidden = true
        if temperatureForecast.isEmpty {
            detailedTempLabel.text = "N/A"
            detailedLikeTempLabel.text = "N/A"
            detailedWeatherDescriptionLabel.text = "N/A"
            detailedPressureLabel.text = "N/A"
            detailedHumidityLabel.text = "N/A"
            detailedCloudityLabel.text = "N/A"
            detailedProbabilityLabel.text = "N/A"
            detailedVisibilityLabel.text = "N/A"
            detailedWindSpeedLabel.text = "N/A"
            detailedWindDirectionLabel.text = "N/A"
            detailedWindGustLabel.text = "N/A"
            
        } else
        
        { detailedTempLabel.text = " \(temperatureForecast[indexPath.row]) ºC"
            
            detailedLikeTempLabel.text = " \(feelsLikeForecast[indexPath.row]) ºC"
            
            detailedWeatherDescriptionLabel.text = " \(weatherDescription[indexPath.row])"
            
            detailedPressureLabel.text = " \(pressure[indexPath.row]) hPa"
            detailedHumidityLabel.text = " \(humidity[indexPath.row])%"
            detailedCloudityLabel.text = " \(cloudiness[indexPath.row])%"
            detailedProbabilityLabel.text = "\(pop[indexPath.row])%"
            detailedVisibilityLabel.text = " \(visibility[indexPath.row]) meters"
            detailedWindSpeedLabel.text = " \(speed[indexPath.row]) m/s"
            detailedWindDirectionLabel.text = "Wind direction \(deg[indexPath.row])º"
            windDirection.image = UIImage(systemName: windDirectionString[indexPath.row])
            detailedWindGustLabel.text = " \(gust[indexPath.row]) m/s"
            
        }
        
        detailedView.isHidden = false
        
    }
    
    
}
