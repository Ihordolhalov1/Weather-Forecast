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
    let country: String
    let population, timezone, sunrise, sunset: Int
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
    let sys: Sys
    let wind: Wind
    let clouds: Clouds
    let pop: Double
    let visibility: Int

}

// MARK: - Sys
struct Sys: Codable {
    let pod: Pod
}

enum Pod: String, Codable {
    case d = "d"
    case n = "n"
}



// MARK: - MainClass
struct MainClass: Codable {
    let temp, feelsLike, humidity, pressure: Double
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case humidity
        case pressure
       
    }
}




// MARK: - Weather
struct Weather: Codable {
    let id: Int
    let description: String
}



// MARK: - Wind
struct Wind: Codable {
    let speed: Double
    let deg: Int
    let gust: Double
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int
}




