//
//  ForecastViewController.swift
//  WeatherApp
//
//  Created by Darkhan Serkeshev on 27.08.2021.
//

import UIKit

// TODO: 5 - Добавить в таб бар дополнительную вкладку (Forecast)
class ForecastViewController: UIViewController {
    
    private var presenter: ForecastPresenter!
    
    private var forecasts: [ForecastModel.Daily] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - UI Components Beginning
    private let backgoundImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "forecastPageBackground"))
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = NSLocalizedString("Forecast", comment: "")
        label.font = UIFont.systemFont(ofSize: 32, weight: .light)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.delegate = self
        tv.dataSource = self
        tv.separatorStyle = .singleLine
        tv.backgroundColor = .clear
        tv.register(ForecastCell.self, forCellReuseIdentifier: ForecastCell.identifier)
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        getForecastWeather()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getForecastWeather()
    }
}

// MARK: - Internal functions
extension ForecastViewController {
    
    private func configureViews() {
        view.addSubview(backgoundImageView)
        view.addSubview(titleLabel)
        view.addSubview(tableView)

        backgoundImageView.anchor(top: view.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor)
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: tableView.topAnchor, paddingBottom: 8)
        tableView.anchor(leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor)
    }
    
    private func getForecastWeather() {
        presenter = ForecastPresenter(controller: self)
        presenter.getForecastWeather()
    }
}

// MARK: - ForecastPresenterOutput
extension ForecastViewController: ForecastPresenterOutput {
    
    func setForecastWeather(forecasts: ForecastModel) {
        self.forecasts = forecasts.daily
    }
}

// MARK: - UITabBarDelegate, UITableViewDataSource
extension ForecastViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecasts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ForecastCell.identifier, for: indexPath) as! ForecastCell
        cell.forecast = forecasts[indexPath.row]
        return cell
    }
}


