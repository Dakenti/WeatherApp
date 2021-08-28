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
}

// MARK: - Public API
extension NetworkManager {
    
    func getCurrentWeatherByLocation(latitude: String, longitude: String, _ complition: @escaping (WeatherModel?) -> (Void)) {
        let urlQueryItems = [
            URLQueryItem(name: "lat", value: latitude),
            URLQueryItem(name: "lon", value: longitude)
        ]
        getCurrentWeather(urlString: Constants.weatherMain, urlQueryItems: urlQueryItems, model: WeatherModel.self, complition)
    }
    
    func getCurrentWeatherByCityName(cityName: String, _ complition: @escaping (WeatherModel?) -> (Void)) {
        let urlQueryItems = [
            URLQueryItem(name: "q", value: cityName)
        ]
        getCurrentWeather(urlString: Constants.weatherMain, urlQueryItems: urlQueryItems, model: WeatherModel.self, complition)
    }
    
    func getCurrentWeatherForecast(latitude: String, longitude: String, _ complition: @escaping (ForecastModel?) -> (Void)) {
        let urlQueryItems = [
            URLQueryItem(name: "lat", value: latitude),
            URLQueryItem(name: "lon", value: longitude),
            URLQueryItem(name: "exclude", value: "hourly"),
            URLQueryItem(name: "appid", value: Constants.apiKey),
            URLQueryItem(name: "units", value: "metric")
        ]
        getCurrentWeather(urlString: Constants.weatherForecast, urlQueryItems: urlQueryItems, model: ForecastModel.self, complition)
    }
}

// MARK: - Internal Private Methods
extension NetworkManager {
    
    private func getCurrentWeather<T: Decodable>(urlString: String, urlQueryItems: [URLQueryItem], model: T.Type, _ complition: @escaping (T?) -> (Void)) {
        guard let localLang = Bundle.main.preferredLocalizations.first?.prefix(2) else { return }
        
        var urlComponents = URLComponents(string: urlString)
        urlComponents?.queryItems = [
            URLQueryItem(name: "appid", value: Constants.apiKey),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "lang", value: String(localLang))
        ]
        print(String(localLang))
        urlComponents?.queryItems! += urlQueryItems
        
        if let url = urlComponents?.url?.absoluteURL {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error == nil {
                    do {
                        if let data = data {
                            let response = try JSONDecoder().decode(model.self, from: data)
                            DispatchQueue.main.async {
                                complition(response)
                            }
                        }
                    } catch {
                        print(error)
                    }
                } else {
                    DispatchQueue.main.async {
                        complition(nil)
                    }
                }
            }.resume()
        }
    }
}
