//
//  ForecastPresenter.swift
//  WeatherApp
//
//  Created by Darkhan Serkeshev on 27.08.2021.
//

import Foundation

protocol ForecastPresenterInput {
    func getForecastWeather()
}

protocol ForecastPresenterOutput: NSObjectProtocol {
    func setForecastWeather(forecasts: ForecastModel)
}

class ForecastPresenter {
    
    private var networkManager: NetworkManager = NetworkManager.shared
    private var coreDataManager: CoreDataManager = CoreDataManager.shared
    
    private weak var controller: ForecastPresenterOutput!

    init(controller: ForecastPresenterOutput) {
        self.controller = controller
    }
}

// MARK: - ForecastPresenterInput
extension ForecastPresenter: ForecastPresenterInput {
    
    func getForecastWeather() {
        if let savedWeather = coreDataManager.getCurrentWeather() {
            networkManager.getCurrentWeatherForecast(latitude: "\(savedWeather.coord.lat)", longitude: "\(savedWeather.coord.lon)") { [weak self] forecast in
                if let forecast = forecast {
                    self?.controller.setForecastWeather(forecasts: forecast)
                }
            }
        }
    }
}
