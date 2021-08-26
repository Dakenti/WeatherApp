//
//  MainModel.swift
//  WeatherApp
//
//  Created by Darkhan Serkeshev on 26.08.2021.
//

import Foundation

class WeatherModel: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
    
    class Main: Decodable {
        let temp: Double
    }
    
    class Weather: Decodable {
        let id: Int
    }
}
