//
//  SearchCityViewController.swift
//  WeatherApp
//
//  Created by Daniel Park on 2025-07-23.
//

// SearchCityViewController.swift

import UIKit

class SearchCityViewController: UICollectionViewController,
                                UISearchBarDelegate,
                                UICollectionViewDelegateFlowLayout {
    private var results: [City] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search City"
        collectionView.backgroundColor = .white
        collectionView.register(UICollectionViewCell.self,
                                forCellWithReuseIdentifier: "Cell")

        if let layout = collectionView.collectionViewLayout
                  as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.sectionInset = .init(top: 8, left: 8, bottom: 8, right: 8)
            layout.minimumLineSpacing = 8
        }

        let sb = UISearchBar()
        sb.delegate = self
        sb.placeholder = "Type city name, then tap Search"
        navigationItem.titleView = sb
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let text = searchBar.text, text.count >= 2 else { return }
        CitySearchService.searchCity(input: text) { cities in
            self.results = cities
            self.collectionView.reloadData()
        }
    }

    override func collectionView(_ cv: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return results.count
    }

    override func collectionView(_ cv: UICollectionView,
                                 cellForItemAt ip: IndexPath)
                                 -> UICollectionViewCell {
        let city = results[ip.item]
        let cell = cv.dequeueReusableCell(withReuseIdentifier: "Cell",
                                          for: ip)
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }

        let lbl = UILabel(frame: cell.contentView.bounds)
        lbl.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        lbl.text = "\(city.name), \(city.stateCode), \(city.countryCode)"
        lbl.font = .systemFont(ofSize: 16)
        cell.contentView.addSubview(lbl)

        cell.backgroundColor = .systemGray6
        cell.layer.cornerRadius = 8
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = UIColor.lightGray.cgColor
        return cell
    }

    override func collectionView(_ cv: UICollectionView,
                                 didSelectItemAt ip: IndexPath) {
        let city = results[ip.item]

        var saved = CityStorage.load()
        saved.append(city)
        CityStorage.save(saved)

        let sb = UIStoryboard(name: "Main", bundle: nil)
        let dvc = sb.instantiateViewController(
            withIdentifier: "DetailViewController"
        ) as! DetailViewController
        dvc.city = city
        navigationController?.pushViewController(dvc, animated: true)
    }

    func collectionView(_ cv: UICollectionView,
                        layout cl: UICollectionViewLayout,
                        sizeForItemAt ip: IndexPath) -> CGSize {
        let w = cv.bounds.width - 16
        return CGSize(width: w, height: 50)
    }
}

