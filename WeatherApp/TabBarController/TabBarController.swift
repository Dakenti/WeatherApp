//
//  TabBarController.swift
//  WeatherApp
//
//  Created by Darkhan Serkeshev on 26.08.2021.
//

import UIKit

// TODO: 2.a - Таб бар
class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTransparentTabbar()
        delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let mainVC = MainViewController()
        let mainVCItem = UITabBarItem(title: NSLocalizedString("Main", comment: ""), image: UIImage(named: "thermostat"), selectedImage: UIImage(named: "thermostatSelected"))
        mainVC.tabBarItem = mainVCItem
        
        let forecastVC = ForecastViewController()
        let forecastVCIcon = UITabBarItem(title: NSLocalizedString("Forecast", comment: ""), image: UIImage(named: "storm"), selectedImage: UIImage(named: "stormSelected"))
        forecastVC.tabBarItem = forecastVCIcon
        
        let controllers = [mainVC, forecastVC]
        
        self.viewControllers = controllers
    }
    
    func setTransparentTabbar() {
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().shadowImage     = UIImage()
        UITabBar.appearance().clipsToBounds   = true
    }
}

extension TabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }
}
