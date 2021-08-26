//
//  MainPresenter.swift
//  WeatherApp
//
//  Created by Darkhan Serkeshev on 26.08.2021.
//

import Foundation

protocol MainPresanterOutput: NSObjectProtocol {
    func setCurrentWeather(_ weather: WeatherModel)
    func setWeatherCondition(imageName: String)
    func getWeatherConditionText(_ text: String)
}

protocol MainPresenterInput {
    func getCurrentWeatherByLocation()
    func getCurrentWeatherByCityName(cityName: String)
    func getWeatherCondition(condition: Int)
    func getWeatherConditionText(temperature: Double)
}

class MainPresenter {
    
    private var networkManager: NetworkManager = NetworkManager.shared
    private var locationManager: LocationManager = LocationManager.shared
    
    private weak var controller: MainPresanterOutput!

    init(controller: MainPresanterOutput) {
        self.controller = controller
    }
}

extension MainPresenter: MainPresenterInput {
        
    func getCurrentWeatherByLocation() {
        locationManager.getCurrentLocation = { [weak self] (latitude, longitude) in
            self?.networkManager.getCurrentWeatherByLocation(latitude: latitude, longitude: longitude) { weather in
                self?.controller.setCurrentWeather(weather)
            }
        }
    }
    
    func getCurrentWeatherByCityName(cityName: String) {
        networkManager.getCurrentWeatherByCityName(cityName: cityName) { [weak self] weather in
            self?.controller.setCurrentWeather(weather)
        }
    }
}

extension MainPresenter {
    
    func getWeatherCondition(condition: Int) {
        var weatherCondition: String = ""
        switch (condition) {
        case 0...300 :
            weatherCondition = "tstorm1"
        case 301...500 :
            weatherCondition = "light_rain"
            controller.getWeatherConditionText("Is it rain or angels are crying???")
        case 501...600 :
            weatherCondition = "shower3"
        case 601...700 :
            weatherCondition = "snow4"
        case 701...771 :
            weatherCondition = "fog"
        case 772...799 :
            weatherCondition = "tstorm3"
        case 800 :
            weatherCondition = "sunny"
        case 801...804 :
            weatherCondition = "cloudy2"
        case 900...903, 905...1000 :
            weatherCondition = "tstorm3"
        case 903 :
            weatherCondition = "snow5"
        case 904 :
            weatherCondition = "sunny"
        default :
            weatherCondition = "dunno"
        }
        
        controller.setWeatherCondition(imageName: weatherCondition)
    }
    
    func getWeatherConditionText(temperature: Double) {
        var text = ""
        if temperature < 0 {
            text = "it is cold, brrr!"
        } else if temperature >= 0 && temperature <= 15 {
            text = "I don't like it but it's OK outside."
        } else if temperature > 15 {
            text = "Let's go outside and walk..."
        }
        controller.getWeatherConditionText(text)
    }
}
