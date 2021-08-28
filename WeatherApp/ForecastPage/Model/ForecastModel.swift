//
//  ForecastModel.swift
//  WeatherApp
//
//  Created by Darkhan Serkeshev on 27.08.2021.
//

import Foundation

public struct ForecastModel: Decodable {
    let daily: [Daily]
    
    struct Daily: Decodable {
        let dayTime: UInt64
        let temp: Temp?
        let feelsLike: FeelsLike?
        let weather: [Weather]?
        
        enum CodingKeys: String, CodingKey {
            case dayTime = "dt"
            case temp
            case feelsLike = "feels_like"
            case weather
        }
        
        struct Temp: Decodable {
            let day: Double?
            let night: Double?
        }
        
        struct FeelsLike: Decodable {
            let day: Double?
            let night: Double?
        }
        
        struct Weather: Decodable {
            let description: String?
        }   
    }
}





