//
//  MainPresenter.swift
//  WeatherApp
//
//  Created by Darkhan Serkeshev on 26.08.2021.
//

import Foundation

protocol MainPresenterOutput: NSObjectProtocol {
    func setCurrentWeather(_ weather: WeatherModel?)
    func setWeatherCondition(_ imageName: String)
    func setWeatherConditionText(_ text: String)
}

protocol MainPresenterInput {
    func getCurrentWeatherByLocation()
    func getCurrentWeatherByCityName(cityName: String)
    func getWeatherCondition(condition: Int, temperature: Double)
}

class MainPresenter {
    
    private var networkManager: NetworkManager = NetworkManager.shared
    private var locationManager: LocationManager = LocationManager.shared
    private var coreDataManager: CoreDataManager = CoreDataManager.shared
    
    private weak var controller: MainPresenterOutput!

    init(controller: MainPresenterOutput) {
        self.controller = controller
    }
}

// MARK: - MainPresenterInput
extension MainPresenter: MainPresenterInput {
        
    func getCurrentWeatherByLocation() {
        locationManager.getCurrentLocation = { [weak self] (location) in
            if let location = location {
                self?.networkManager.getCurrentWeatherByLocation(latitude: "\(location.lat)", longitude: "\(location.lon)", { weather in
                    if let weather = weather {
                        self?.coreDataManager.clearDatabase()
                        self?.coreDataManager.addWeatherCondition(weather)
                        self?.controller.setCurrentWeather(weather)
                    } else if let savedWeather = self?.coreDataManager.getCurrentWeather() {
                        self?.controller.setCurrentWeather(savedWeather)
                    }
                })
            } else {
                self?.controller.setCurrentWeather(nil)
            }
        }
    }
    
    func getCurrentWeatherByCityName(cityName: String) {
        networkManager.getCurrentWeatherByCityName(cityName: cityName) { [weak self] weather in
            if let weather = weather {
                self?.coreDataManager.clearDatabase()
                self?.coreDataManager.addWeatherCondition(weather)
                self?.controller.setCurrentWeather(weather)
            }
        }
    }
    
    // TODO: 2.b - текущая температура в Цельсиях и минимальный комментарий-совет от исполнителя
    // TODO: 7 - Реализовать на экране Main дополнительно отображение иконки текущей погоды
    func getWeatherCondition(condition: Int, temperature: Double) {
        var text: String = ""
        var weatherCondition: String = ""
        
        switch (condition) {
        case 0...300 :
            text = NSLocalizedString("it is storm!", comment: "")
            weatherCondition = "tstorm1"
        case 301...500 :
            text = NSLocalizedString("it is light rain!", comment: "")
            weatherCondition = "light_rain"
        case 501...600 :
            text = NSLocalizedString("it is raining!", comment: "")
            weatherCondition = "shower3"
        case 601...700 :
            text = NSLocalizedString("it is snowing!", comment: "")
            weatherCondition = "snow4"
        case 701...771 :
            text = weatherCondtionText(temperature) //  no precipitation
            weatherCondition = "fog"
        case 772...799 :
            text = NSLocalizedString("it is storm!", comment: "")
            weatherCondition = "tstorm3"
        case 800 :
            text = weatherCondtionText(temperature) //  no precipitation
            weatherCondition = "sunny"
        case 801...804 :
            text = weatherCondtionText(temperature) //  no precipitation
            weatherCondition = "cloudy2"
        case 900...903, 905...1000 :
            text = NSLocalizedString("it is storm!", comment: "")
            weatherCondition = "tstorm3"
        case 903 :
            text = NSLocalizedString("it is snowing!", comment: "")
            weatherCondition = "snow5"
        case 904 :
            text = weatherCondtionText(temperature) //  no precipitation
            weatherCondition = "sunny"
        default :
            text = weatherCondtionText(temperature) //  no precipitation
            weatherCondition = "dunno"
        }

        controller.setWeatherConditionText(text)
        controller.setWeatherCondition(weatherCondition)
    }
    
    private func weatherCondtionText(_ temperature: Double) -> String {
        var text: String = ""
        if temperature < 0 {
            text = NSLocalizedString("it is cold, brrr!", comment: "")
        } else if temperature >= 0 && temperature <= 15 {
            text = NSLocalizedString("I don't like it but it's OK outside.", comment: "")
        } else if temperature > 15 {
            text = NSLocalizedString("Let's go outside and walk...", comment: "")
        }
        
        return text
    }
}
