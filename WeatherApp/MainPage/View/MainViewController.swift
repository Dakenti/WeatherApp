//
//  ViewController.swift
//  WeatherApp
//
//  Created by Darkhan Serkeshev on 26.08.2021.
//

import UIKit

class MainViewController: UIViewController {
    
    private var presenter: MainPresenter!
    
    // MARK: - UI Components Beginning
    private let backgoundImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "mainPageBackground"))
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private lazy var selectCityButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "switch")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(selectCityButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var containerStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [weatherConditionLabel, cityNameLabel, weatherCondtionImageView, temperatureLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 10
        return stack
    }()
    
    private let weatherConditionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "..."
        label.font = UIFont.systemFont(ofSize: 24, weight: .thin)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let cityNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Loading..."
        label.font = UIFont.systemFont(ofSize: 42, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    private let weatherCondtionImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "dunno"))
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.addConstraint(NSLayoutConstraint(item: iv, attribute: .height, relatedBy: .equal, toItem: iv, attribute: .width, multiplier: iv.frame.size.height / iv.frame.size.width, constant: 0))
        return iv
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "... ℃"
        label.font = UIFont.systemFont(ofSize: 32, weight: .thin)
        label.textColor = .white
        label.textAlignment = .right
        return label
    }()
    // MARK: - UI Components End

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        getCurrentWeather()
    }
}

// MARK: - Internal functions
extension MainViewController {
    
    private func configureViews() {
        view.addSubview(backgoundImageView)
        view.addSubview(selectCityButton)
        view.addSubview(containerStack)
        
        backgoundImageView.anchor(top: view.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor)
        selectCityButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor, paddingTop: 16, paddingRight: 16, width: 44, height: 44)
        NSLayoutConstraint.activate([
            containerStack.topAnchor.constraint(greaterThanOrEqualTo: selectCityButton.bottomAnchor, constant: 16),
            containerStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            containerStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            containerStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32)
        ])
    }
    
    private func getCurrentWeather() {
        presenter = MainPresenter(controller: self)
        presenter.getCurrentWeatherByLocation()
    }
    
    @objc private func selectCityButtonPressed() {
        let alert = UIAlertController(title: "Get Weather", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Enter City Name"
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "Get", style: .default, handler: { [weak self] (_) in
            if let cityName = alert.textFields?[0].text {
                self?.presenter.getCurrentWeatherByCityName(cityName: cityName)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - MainPresantable a protocolo to connect with Presenter
extension MainViewController: MainPresenterOutput {

    func setCurrentWeather(_ weather: WeatherModel) {
        cityNameLabel.text = weather.name
        temperatureLabel.text = "\(weather.main.temp) ℃"
        presenter.getWeatherCondition(condition: weather.weather.first?.id ?? 0, temperature: weather.main.temp)
    }
    
    func setWeatherCondition(_ imageName: String) {
        weatherCondtionImageView.image = UIImage(named: imageName)
    }
    
    func setWeatherConditionText(_ text: String) {
        weatherConditionLabel.text = text
    }
}
