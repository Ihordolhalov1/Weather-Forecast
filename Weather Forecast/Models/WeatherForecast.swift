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
    var degree: Int
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
    
    var systemArrowString: String {
        switch degree {
        case 0...22: return "arrow.up"
        case 23...68: return "arrow.up.right"
        case 69...113: return "arrow.right"
        case 114...158: return "arrow.down.right"
        case 159...203: return "arrow.down"
        case 204...247: return "arrow.down.left"
        case 248...292: return "arrow.left"
        case 293...337: return "arrow.up.left"
        case 338...360: return "arrow.up"
        default: return "nosign"
        }
    }
    
    
    
    var date: [String] = [] //масив дат
    var conditionCodeForecast: [Int] = []
    var temperatureForecast: [Double] = [0.0]
    var feelsLikeForecast: [Double] = []
    var description: [String] = []
    var humidity: [Double] = []
    var pressure: [Double] = []
    var cloudiness: [Int] = []
    var pop: [Int] = []
    var visibility: [Int] = []
    var pod: [String] = []  // масив день або ніч
    var speed: [Double] = []
    var deg: [Int] = []
    var windDirectionString: [String] = []
    var gust: [Double] = []
    
    
    init?(currentWeatherData: WeatherForecastData) {
        cityName = currentWeatherData.city.name
        temperature = currentWeatherData.list.first!.main.temp
        feelsLikeTemperature = currentWeatherData.list.first!.main.feelsLike
        conditionCode = currentWeatherData.list.first!.weather.first!.id
        degree = currentWeatherData.list.first!.wind.deg

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
                speed.append(currentWeatherData.list[index].wind.speed)
                deg.append(currentWeatherData.list[index].wind.deg)
                gust.append(currentWeatherData.list[index].wind.gust)
                description.append(currentWeatherData.list[index].weather.first!.description)
                pressure.append(currentWeatherData.list[index].main.pressure)
                humidity.append(currentWeatherData.list[index].main.humidity)
                cloudiness.append(currentWeatherData.list[index].clouds.all)
                pop.append(Int(currentWeatherData.list[index].pop * 100))
                visibility.append(currentWeatherData.list[index].visibility)
                degree = currentWeatherData.list[index].wind.deg
                windDirectionString.append(systemArrowString)
            }
        }
    }
}
