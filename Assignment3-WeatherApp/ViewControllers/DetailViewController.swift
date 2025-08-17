//
//  DetailViewController.swift
//  WeatherApp
//
//  Created by Daniel Park on 2025-07-23.
//

import UIKit

class DetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var city: City!
    var forecast: [Forecast] = []

    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = city.name

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(ForecastCell.self, forCellWithReuseIdentifier: "ForecastCell")

        if let lat = Double(city.latitude), let lon = Double(city.longitude) {
            WeatherService.fetchWeather(lat: lat, lon: lon) { [weak self] response in
                DispatchQueue.main.async {
                    self?.forecast = response?.list ?? []
                    self?.collectionView.reloadData()
                }
            }
        } else {
            print("invalid: \(city.latitude), \(city.longitude)")
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return forecast.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ForecastCell", for: indexPath) as! ForecastCell
        cell.configure(with: forecast[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width - 32, height: 60)
    }
}
