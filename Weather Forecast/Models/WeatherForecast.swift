//
//  File.swift
//  Weather Forecast
//
//  Created by Ihor Dolhalov on 09.04.2023.
//  Copyright © 2023 Ihor Dolhalov. All rights reserved.
//

import Foundation

struct WeatherForecast {
    
    let cityName: String
    let country: String
    let population, timezone, sunrise, sunset: Int

    

    
    let temperature: Double
    var temperatureString: String {
        return String(format: "%.1f", temperature)
    }
    
    let feelsLikeTemperature: Double
    var feelsLikeTemperatureString: String {
        return String(format: "%.1f", feelsLikeTemperature)
    }
    
    let conditionCode: Int
    
    var systemDayIconNameString: String {
        switch conditionCode {
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
    var systemNightIconNameString: String {
        switch conditionCode {
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
    var date: [String] = [] //масив дат
    var conditionCodeForecast: [Int] = []
    var temperatureForecast: [Double] = []
    var feelsLikeForecast: [Double] = []
    var pod: [String] = []  // масив день або ніч
    
    init?(currentWeatherData: WeatherForecastData) {
        cityName = currentWeatherData.city.name
        temperature = currentWeatherData.list.first!.main.temp
        feelsLikeTemperature = currentWeatherData.list.first!.main.feelsLike
        conditionCode = currentWeatherData.list.first!.weather.first!.id
        
        country = currentWeatherData.city.country
        population = currentWeatherData.city.population
        timezone = currentWeatherData.city.timezone
        sunrise = currentWeatherData.city.sunrise
        sunset = currentWeatherData.city.sunset
        
        
        
        for index in 0...currentWeatherData.list.count-1 {
            //створюю масив дат і
            //обрізаю вхідний масив в 2 рази, беру тільки парні індекси, щоб була відстань 6 годин
            if index == 0 || index%2 == 0 {
                date.append(currentWeatherData.list[index].dt_txt)
                temperatureForecast.append(currentWeatherData.list[index].main.temp)
                feelsLikeForecast.append(currentWeatherData.list[index].main.feelsLike)
                conditionCodeForecast.append(currentWeatherData.list[index].weather.first!.id)
                pod.append(currentWeatherData.list[index].sys.pod.rawValue)
                
                
            }
        }
    }
}
