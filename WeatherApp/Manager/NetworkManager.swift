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
    
    func getCurrentWeatherByLocation(latitude: String, longitude: String, _ complition: @escaping (WeatherModel) -> (Void)) {
        let urlQueryItems = [
            URLQueryItem(name: "lat", value: latitude),
            URLQueryItem(name: "lon", value: longitude)
        ]
        getCurrentWeather(urlQueryItems: urlQueryItems, complition)
    }
    
    func getCurrentWeatherByCityName(cityName: String, _ complition: @escaping (WeatherModel) -> (Void)) {
        let urlQueryItems = [
            URLQueryItem(name: "q", value: cityName)
        ]
        getCurrentWeather(urlQueryItems: urlQueryItems, complition)
    }
    
    func getCurrentWeather(urlQueryItems: [URLQueryItem], _ complition: @escaping (WeatherModel) -> (Void)) {
        var urlComponents = URLComponents(string: Constants.weatherMain)
        urlComponents?.queryItems = [
            URLQueryItem(name: "appid", value: Constants.apiKey),
            URLQueryItem(name: "units", value: "metric")
        ]
        
        urlComponents?.queryItems! += urlQueryItems
        
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
