//
//  FavoritesViewController.swift
//  RealEstateFinder
//
//  Created by Daniel Park on 2025-08-03.
//

import UIKit
import CoreData

class FavoritesViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sortSegment: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!

    var favorites: [Property] = []
    var filtered: [Property] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        searchBar.delegate = self
        loadFavorites()
    }

    func loadFavorites() {
        let ctx = CoreDataManager.shared.context
        let req: NSFetchRequest<Property> = Property.fetchRequest()
        favorites = (try? ctx.fetch(req)) ?? []
        filtered = favorites
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { filtered.count }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath)
        cell.textLabel?.text = filtered[indexPath.row].address
        return cell
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filtered = searchText.isEmpty ? favorites : favorites.filter { $0.address?.lowercased().contains(searchText.lowercased()) ?? false }
        tableView.reloadData()
    }

    @IBAction func sortChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 { filtered.sort { $0.price < $1.price } }
        else { filtered.sort { $0.bedrooms < $1.bedrooms } }
        tableView.reloadData()
    }

    @IBAction func logoutTapped(_ sender: UIButton) { dismiss(animated: true) }
}
