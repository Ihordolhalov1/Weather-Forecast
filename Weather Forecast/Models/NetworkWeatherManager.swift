//
//  File.swift
//  Weather Forecast
//
//  Created by Ihor Dolhalov on 09.04.2023.
//  Copyright © 2023 Ihor Dolhalov. All rights reserved.
//

import Foundation
import CoreLocation

class NetworkWeatherManager {
    
    enum RequestType {
        case cityName(city: String)
        case coordinate(latitude: CLLocationDegrees, longitude: CLLocationDegrees)
    }
    
    var onCompletion: ((WeatherForecast) -> Void)?
    
    func fetchCurrentWeather(forRequestType requestType: RequestType) {
        var urlString = ""
        switch requestType {
        case .cityName(let city):
            urlString = "https://api.openweathermap.org/data/2.5/forecast?q=\(city)&appid=\(apiKey)&units=metric"
        case .coordinate(let latitude, let longitude):
            urlString =
    "https://api.openweathermap.org/data/2.5/forecast?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric"
        }
        performRequest(withURLString: urlString)
    }
    
    fileprivate func performRequest(withURLString urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            if let data = data {
               // let dataString = String(data: data, encoding: .utf8)
                print("ОТРИМАВ ДАНІ ВІД СЕРВЕРА, Віддаю на парсінг")
                if let currentWeather = self.parseJSON(withData: data) {
                    self.onCompletion?(currentWeather)
                    print(currentWeather)
                }
            }
        }
        task.resume()
    }
    
    fileprivate func parseJSON(withData data: Data) -> WeatherForecast? {
        let decoder = JSONDecoder()
        do {
            let currentWeatherData = try decoder.decode(WeatherForecastData.self, from: data)
            
            guard let currentWeather = WeatherForecast(currentWeatherData: currentWeatherData) else {
                return nil
            }
            print("УСПІШНО ЗАПАРСИВ")
            return currentWeather
        } catch let error as NSError {
            print(error.localizedDescription)
            print("НЕ ХОЧЕТ ПАРСИТЬСЯ")
        }
        return nil
    }
}
