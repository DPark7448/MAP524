//
//  ForecastCell.swift
//  WeatherApp
//
//  Created by Daniel Park on 2025-07-23.
//

import UIKit

class ForecastCell: UICollectionViewCell {
    let label = UILabel()
    let tempLabel = UILabel()
    let iconView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemGroupedBackground
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 0.5
        contentView.layer.borderColor = UIColor.lightGray.cgColor

        label.translatesAutoresizingMaskIntoConstraints = false
        tempLabel.translatesAutoresizingMaskIntoConstraints = false
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.contentMode = .scaleAspectFit

        contentView.addSubview(label)
        contentView.addSubview(tempLabel)
        contentView.addSubview(iconView)

        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            iconView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 40),
            iconView.heightAnchor.constraint(equalToConstant: 40),

            label.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),

            tempLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
            tempLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 4),
            tempLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            tempLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -12)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init coderhas not been implemented")
    }

    func configure(with forecast: Forecast) {
        label.text = forecast.dt_txt
        tempLabel.text = "🌡️ \(forecast.main.temp)°C"

        if let iconCode = forecast.weather.first?.icon {
            let iconURL = URL(string: "https://openweathermap.org/img/wn/\(iconCode)@2x.png")
            if let url = iconURL {
                URLSession.shared.dataTask(with: url) { data, _, _ in
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.iconView.image = image
                        }
                    }
                }.resume()
            }
        }
    }
}
