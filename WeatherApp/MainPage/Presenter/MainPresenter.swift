//
//  MainPresenter.swift
//  WeatherApp
//
//  Created by Darkhan Serkeshev on 26.08.2021.
//

import Foundation

protocol MainPresantable: NSObjectProtocol {
    func setCurrentWeather(_ weather: WeatherModel)
}

protocol MainPresenterProtocol {
    func getCurrentWeather()
}

class MainPresenter {
    
    private var networkManager: NetworkManager = NetworkManager.shared
    private var locationManager: LocationManager = LocationManager.shared
    
    private weak var controller: MainPresantable!

    init(controller: MainPresantable) {
        self.controller = controller
    }
}

extension MainPresenter: MainPresenterProtocol {
    
    func getCurrentWeather() {
        locationManager.getCurrentLocation = { [weak self] (latitude, longitude) in
            self?.networkManager.getCurrentWeather(latitude: latitude, longitude: longitude) { weather in
                self?.controller.setCurrentWeather(weather)
            }
        }
    }
}

extension MainPresenter {
    func updateWeatherIcon(condition: Int) -> String {
        switch (condition) {
        case 0...300 :
            return "tstorm1"
        case 301...500 :
            return "light_rain"
        case 501...600 :
            return "shower3"
        case 601...700 :
            return "snow4"
        case 701...771 :
            return "fog"
        case 772...799 :
            return "tstorm3"
        case 800 :
            return "sunny"
        case 801...804 :
            return "cloudy2"
        case 900...903, 905...1000 :
            return "tstorm3"
        case 903 :
            return "snow5"
        case 904 :
            return "sunny"
        default :
            return "dunno"
        }
    }
}
