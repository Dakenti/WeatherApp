//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by Darkhan Serkeshev on 26.08.2021.
//

import Foundation

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func getCurrentWeather(latitude: String, longitude: String, _ complition: @escaping (WeatherModel) -> (Void)) {
        var urlComponents = URLComponents(string: Constants.weatherMain)
        urlComponents?.queryItems = [
            URLQueryItem(name: "appid", value: Constants.apiKey),
            URLQueryItem(name: "lat", value: latitude),
            URLQueryItem(name: "lon", value: longitude),
            URLQueryItem(name: "units", value: "metric")
        ]
        
        if let url = urlComponents?.url?.absoluteURL {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error == nil {
                    do {
                        if let data = data {
                            let weatherData = try JSONDecoder().decode(WeatherModel.self, from: data)
                            DispatchQueue.main.async {
                                complition(weatherData)
                            }
                        }
                    } catch {
                        print(error)
                    }
                }
            }.resume()
        }
    }
}
