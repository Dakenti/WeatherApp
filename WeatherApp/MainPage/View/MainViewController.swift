//
//  ViewController.swift
//  WeatherApp
//
//  Created by Darkhan Serkeshev on 26.08.2021.
//

import UIKit

class MainViewController: UIViewController {
    
    private var presenter: MainPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCurrentWeather()
    }
}

// MARK: - Internal functions
extension MainViewController {
    
    func getCurrentWeather() {
        presenter = MainPresenter(controller: self)
        presenter.getCurrentWeather()
    }
}

// MARK: - MainPresantable a protocolo to connect with Presenter
extension MainViewController: MainPresantable {
    
    func setCurrentWeather(_ weather: WeatherModel) {
        print(weather.name)
    }
}
