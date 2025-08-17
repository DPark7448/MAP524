//
//  SearchViewController.swift
//  MealPlanner
//
//  Created by Daniel Park on 2025-08-11.
//

import UIKit

final class SearchViewController: UITableViewController, UISearchBarDelegate {
  private let currentUser: User
  private let onSelect: (Recipe) -> Void
  private var results: [Recipe] = []
  private let searchController = UISearchController(searchResultsController: nil)

  init(currentUser: User, onSelect: @escaping (Recipe) -> Void) {
    self.currentUser = currentUser
    self.onSelect = onSelect
    super.init(style: .plain)
  }
  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Search"
    tableView.register(FavCell.self, forCellReuseIdentifier: "cell")
    navigationItem.searchController = searchController
    searchController.searchBar.delegate = self
    Task { // show featured on load for nice UX
      if results.isEmpty {
        if let feats = try? await TastyAPI.shared.featured() { self.results = feats; self.tableView.reloadData() }
      }
    }
  }

  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    guard let text = searchBar.text, !text.trimmingCharacters(in: .whitespaces).isEmpty else { return }

    Task {
      do {
        let items = try await TastyAPI.shared.searchRecipes(query: text)
        self.results = items
        self.tableView.reloadData()
      } catch {
        print("Search error: \(error)")
      }
    }
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { results.count }
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FavCell
    let r = results[indexPath.row]
    cell.configure(name: r.name, imageURL: r.thumbnail_url)
    return cell
  }
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let r = results[indexPath.row]
    onSelect(r)
  }
}
