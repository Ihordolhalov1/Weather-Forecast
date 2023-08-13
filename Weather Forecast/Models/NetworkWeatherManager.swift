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
    
    var onCompletionForecast: ((WeatherForecast) -> Void)?
    var onCompletionCurrent: ((CurrentWeather) -> Void)?
    
    func fetchWeatherForecast(forRequestType requestType: RequestType) {
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
                print("ОТРИМАВ ДАНІ ВІД СЕРВЕРА ПРОГНОЗ ПОГОДИ, Віддаю на парсінг")
                if let weatherForecast = self.parseJSONForecast(withData: data) {
                    self.onCompletionForecast?(weatherForecast)
                    print("Зараз роздрукую структуру weatherForecast")
                    print(weatherForecast)
                }
            }
        }
        task.resume()
    }
    
    fileprivate func parseJSONForecast(withData data: Data) -> WeatherForecast? {
        let decoder = JSONDecoder()
        do {
            let WeatherForecastData = try decoder.decode(WeatherForecastData.self, from: data)
            
            guard let Weather = WeatherForecast(currentWeatherData: WeatherForecastData) else {
                return nil
            }
            print("УСПІШНО ЗАПАРСИВ")
            return Weather
        } catch let error as NSError {
            print(error.localizedDescription)
            print("НЕ ХОЧЕТ ПАРСИТЬСЯ")
        }
        return nil
    }
    
    fileprivate func parseJSONCurrentWeather(withData data: Data) -> CurrentWeather? {
        let decoder = JSONDecoder()
        do {
            let CurrentWeatherData = try decoder.decode(CurrentWeatherData.self, from: data)
            
            guard let Weather = CurrentWeather(currentWeatherData: CurrentWeatherData) else {
                return nil
            }
            print("УСПІШНО ЗАПАРСИВ ПОТОЧНІ ДАНІ")
            print (Weather)
            return Weather
        } catch let error as NSError {
            print(error.localizedDescription)
            print("НЕ ХОЧЕТ ПАРСИТЬСЯ")
        }
        return nil
    }

    
    fileprivate func performRequestToCurrent(withURLString urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            if let data = data {
               // let dataString = String(data: data, encoding: .utf8)
                print("ОТРИМАВ ДАНІ ВІД СЕРВЕРА ПОТОЧНА ПОГОДА, Віддаю на парсінг")
                if let currentWeather = self.parseJSONCurrentWeather(withData: data) {
                    self.onCompletionCurrent?(currentWeather)
                    print("Зараз роздрукую структуру currentWeather")
                    print(currentWeather)
                }
            }
        }
        task.resume()
    }
    
    func fetchCurrentWeather(forRequestType requestType: RequestType) {
        var urlString = ""
        switch requestType {
        case .cityName(let city):
            urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric"
        case .coordinate(let latitude, let longitude):
            urlString =
    "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric"
        }
        performRequestToCurrent(withURLString: urlString)
    }
    
    
    
    
}



