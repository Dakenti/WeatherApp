//
//  MainModel.swift
//  WeatherApp
//
//  Created by Darkhan Serkeshev on 26.08.2021.
//

import Foundation

struct WeatherModel: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
    let coord: Coordinate
    
    struct Main: Decodable {
        let temp: Double
        
        init(temp: Double) {
            self.temp = temp
        }
    }
    
    struct Weather: Decodable {
        let id: Int
        
        init(id: Int) {
            self.id = id
        }
    }
    
    struct Coordinate: Decodable {
        let lat: Double
        let lon: Double
        
        init(lat: Double, lon: Double) {
            self.lat = lat
            self.lon = lon
        }
    }
    
    init(weather: ForecastEntity) {
        self.name = weather.cityName ?? ""
        self.main = Main(temp: Double(weather.temperature!) ?? 0.0)
        self.weather = [Weather(id: Int(weather.weatherCondition!) ?? 0)]
        self.coord = Coordinate(lat: Double(weather.latitude!) ?? 0, lon: Double(weather.longitude!) ?? 0)
    }
}
