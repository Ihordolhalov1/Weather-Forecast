//
//  CurrentWeather.swift
//  Always Sunny In My Family
//
//  Created by Ihor Dolhalov on 13.08.2023.
//  Copyright © 2023 Ihor Dolhalov. All rights reserved.
//

import Foundation

struct CurrentWeather {

    
    let temperature: Double
    var temperatureString: String {
        return String(format: "%.1f", temperature)
    }
    
    let feelsLikeTemperature: Double
    var feelsLikeTemperatureString: String {
        return String(format: "%.1f", feelsLikeTemperature)
    }
    
    
    
    init?(currentWeatherData: CurrentWeatherData) {
        temperature = currentWeatherData.main.temp
        feelsLikeTemperature = currentWeatherData.main.feelsLike
    }
}
