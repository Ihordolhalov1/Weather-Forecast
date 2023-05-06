//
//  File.swift
//  Weather Forecast
//
//  Created by Ihor Dolhalov on 09.04.2023.
//  Copyright © 2023 Ihor Dolhalov. All rights reserved.
//

import Foundation

struct CurrentWeather {
    let cityName: String
    
    let temperature: Double
    var temperatureString: String {
        return String(format: "%.1f", temperature)
    }
    
    let feelsLikeTemperature: Double
    var feelsLikeTemperatureString: String {
        return String(format: "%.1f", feelsLikeTemperature)
    }
    
    let conditionCode: Int
    var systemIconNameString: String {
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
    var date: [String] = []
    var temperatureForecast: [Double] = []
    var feelsLikeForecast: [Double] = []
    
    init?(currentWeatherData: CurrentWeatherData) {
        cityName = currentWeatherData.city.name
        temperature = currentWeatherData.list.first!.main.temp
        feelsLikeTemperature = currentWeatherData.list.first!.main.feelsLike
        conditionCode = currentWeatherData.list.first!.weather.first!.id
        for index in 0...currentWeatherData.list.count-1 {
            if index == 0 || index%2 == 0 {
                date.append(currentWeatherData.list[index].dt_txt)
                temperatureForecast.append(currentWeatherData.list[index].main.temp)
                feelsLikeForecast.append(currentWeatherData.list[index].main.feelsLike)
            }
        }
    }
}
