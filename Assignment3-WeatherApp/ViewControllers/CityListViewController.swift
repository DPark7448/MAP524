//
//  CityListViewController.swift
//  WeatherApp
//
//  Created by Daniel Park on 2025-07-23.
//
import UIKit

class CityListViewController: UITableViewController {
    private var cities: [City] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Cities"
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "CityCell")
        loadCities()
    }

    private func loadCities() {
        cities = CityStorage.load()
        tableView.reloadData()
    }


    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath)
                            -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "CityCell",
            for: indexPath
        )
        let c = cities[indexPath.row]
        cell.textLabel?.text = c.name
        return cell
    }


    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        let city = cities[indexPath.row]
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let dvc = sb.instantiateViewController(
            withIdentifier: "DetailViewController"
        ) as! DetailViewController
        dvc.city = city
        navigationController?.pushViewController(dvc, animated: true)
    }


    @IBAction func addCityTapped(_ sender: UIBarButtonItem) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let svc = sb.instantiateViewController(
            withIdentifier: "SearchCityViewController"
        ) as! SearchCityViewController
        navigationController?.pushViewController(svc, animated: true)
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadCities()
    }
}
