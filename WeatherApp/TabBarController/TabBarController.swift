//
//  TabBarController.swift
//  WeatherApp
//
//  Created by Darkhan Serkeshev on 26.08.2021.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let mainVC = MainViewController()
        let mainVCItem = UITabBarItem(title: "Main", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        mainVC.tabBarItem = mainVCItem
        
//        let mainVC = MainViewController()
//        let mainVCIcon = UITabBarItem(title: "Main", image: UIImage(named: "someImage.png"), selectedImage: UIImage(named: "otherImage.png"))
//        mainVC.tabBarItem = mainVCIcon
        
        let controllers = [mainVC]
        
        self.viewControllers = controllers
    }
}

extension TabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }
}
