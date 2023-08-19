//
//  CurrentWeatherData.swift
//  Always Sunny In My Family
//
//  Created by Ihor Dolhalov on 14.08.2023.
//  Copyright © 2023 Ihor Dolhalov. All rights reserved.
//


import Foundation

struct CurrentWeatherData: Codable {
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
    let feelsLike: Double
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
    }
}


