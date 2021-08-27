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
    
    private weak var controller: MainPresenterOutput!

    init(controller: MainPresenterOutput) {
        self.controller = controller
    }
}

extension MainPresenter: MainPresenterInput {
        
    func getCurrentWeatherByLocation() {
        locationManager.getCurrentLocation = { [weak self] (location) in
            if let location = location {
                self?.networkManager.getCurrentWeatherByLocation(latitude: location.latitude, longitude: location.longitude) { weather in
                    self?.controller.setCurrentWeather(weather)
                }
            } else {
                self?.controller.setCurrentWeather(nil)
            }
        }
    }
    
    func getCurrentWeatherByCityName(cityName: String) {
        networkManager.getCurrentWeatherByCityName(cityName: cityName) { [weak self] weather in
            self?.controller.setCurrentWeather(weather)
        }
    }
        
    func getWeatherCondition(condition: Int, temperature: Double) {
        var text: String = ""
        var weatherCondition: String = ""
        
        switch (condition) {
        case 0...300 :
            text = "it is storm!"
            weatherCondition = "tstorm1"
        case 301...500 :
            text = "it is light rain!"
            weatherCondition = "light_rain"
        case 501...600 :
            text = "it is raining!"
            weatherCondition = "shower3"
        case 601...700 :
            text = "it is snowing!"
            weatherCondition = "snow4"
        case 701...771 :
            text = weatherCondtionText(temperature) //  no precipitation
            weatherCondition = "fog"
        case 772...799 :
            text = "it is storm!"
            weatherCondition = "tstorm3"
        case 800 :
            text = weatherCondtionText(temperature) //  no precipitation
            weatherCondition = "sunny"
        case 801...804 :
            text = weatherCondtionText(temperature) //  no precipitation
            weatherCondition = "cloudy2"
        case 900...903, 905...1000 :
            text = "it is storm!"
            weatherCondition = "tstorm3"
        case 903 :
            text = "it is snowing!"
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
            text = "it is cold, brrr!"
        } else if temperature >= 0 && temperature <= 15 {
            text = "I don't like it but it's OK outside."
        } else if temperature > 15 {
            text = "Let's go outside and walk..."
        }
        
        return text
    }
}
