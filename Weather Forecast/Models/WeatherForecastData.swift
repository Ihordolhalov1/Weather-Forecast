//
//  File.swift
//  Weather Forecast
//
//  Created by Ihor Dolhalov on 09.04.2023.
//  Copyright © 2023 Ihor Dolhalov. All rights reserved.
//

import Foundation



// MARK: - Welcome
struct WeatherForecastData: Codable {
    let list: [List]
    let city: City
}



// MARK: - City
struct City: Codable {
    let id: Int
    let name: String
    let coord: Coord
}


// MARK: - Coord
struct Coord: Codable {
    let lat, lon: Double
}

// MARK: - List
struct List: Codable {
    let main: MainClass
    let weather: [Weather]
    let dt_txt: String


}




// MARK: - MainClass
struct MainClass: Codable {
    let temp, feelsLike: Double
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
    }
}




// MARK: - Weather
struct Weather: Codable {
    let id: Int
}










/*

struct CurrentWeatherData: Codable {
    let name: String
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

struct Weather: Codable {
    let id: Int
}
*/
