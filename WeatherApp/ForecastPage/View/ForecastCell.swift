//
//  ForecastCell.swift
//  WeatherApp
//
//  Created by Darkhan Serkeshev on 27.08.2021.
//

import UIKit

class ForecastCell: UITableViewCell {
    
    public static let identifier: String = "ForecastCell"
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "... ℃"
        label.font = UIFont.systemFont(ofSize: 20, weight: .light)
        label.textColor = .black
        label.textAlignment = .right
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "..."
        label.font = UIFont.systemFont(ofSize: 18, weight: .light)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    private lazy var containerStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [dateLabel, temperatureLabel])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillEqually
        stack.spacing = 10
        return stack
    }()
    
    public var forecast: ForecastModel.Daily? {
        didSet {
            if let forecast = forecast {
                temperatureLabel.text = "\(forecast.temp?.day ?? 0) ℃"
                
                let date = Date(timeIntervalSince1970: TimeInterval(forecast.dayTime))
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = DateFormatter.Style.long
                dateFormatter.timeZone = .current
                let localDate = dateFormatter.string(from: date)
                dateLabel.text = localDate
            }
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
        
        addSubview(containerStack)
        containerStack.anchor(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, paddingLeft: 16, paddingRight: 16)
        let containerStackHeightAnchor = containerStack.heightAnchor.constraint(equalToConstant: 60)
        containerStackHeightAnchor.priority = UILayoutPriority(999)
        containerStackHeightAnchor.isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
