//
//  FavoritesViewController.swift
//  MealPlanner
//
//  Created by Daniel Park on 2025-08-11.
//

import UIKit
import CoreData
import SafariServices

struct FavoriteSection { let tag: String; let items: [Favorite] }

final class FavoritesViewController: UITableViewController {
  private let currentUser: User
  private var favorites: [Favorite] = [] { didSet { rebuildSections() } }
  private var sections: [FavoriteSection] = []

  init(currentUser: User) { self.currentUser = currentUser; super.init(style: .insetGrouped) }
  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Favorites"
    navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .search, primaryAction: UIAction { [weak self] _ in
      guard let self = self else { return }
      self.navigationController?.pushViewController(SearchViewController(currentUser: self.currentUser, onSelect: { [weak self] r in self?.showDetails(for: r) }), animated: true)
    })
    tableView.register(FavCell.self, forCellReuseIdentifier: "cell")
    fetchFavorites()
  }

  private func fetchFavorites() {
    let req: NSFetchRequest<Favorite> = Favorite.fetchRequest()
    req.predicate = NSPredicate(format: "owner == %@", currentUser)
    req.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
    do { favorites = try CoreDataStack.shared.context.fetch(req) } catch { print(error) }
  }

  private func rebuildSections() {
    var buckets: [String: [Favorite]] = [:]
    for f in favorites {
      let data = (f.tagsJSON ?? "[]").data(using: .utf8) ?? Data()
      let tags = (try? JSONDecoder().decode([String].self, from: data)) ?? []
      if tags.isEmpty { buckets["Untagged", default: []].append(f) }
      for t in tags { buckets[t.capitalized, default: []].append(f) }
    }
    let keys = buckets.keys.sorted()
    sections = keys.map { FavoriteSection(tag: $0, items: buckets[$0] ?? []) }
    tableView.reloadData()
  }

  private func showDetails(for recipe: Recipe) {
    navigationController?.pushViewController(MealDetailsViewController(currentUser: currentUser, recipe: recipe), animated: true)
  }

  override func numberOfSections(in tableView: UITableView) -> Int { sections.count }
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? { sections[section].tag }
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { sections[section].items.count }
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FavCell
    let item = sections[indexPath.section].items[indexPath.row]
    cell.configure(name: item.name, imageURL: item.imageURL)
    return cell
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let f = sections[indexPath.section].items[indexPath.row]
    // Open in Safari (or load via Search by id)
    if let urlStr = f.recipeURL, let url = URL(string: urlStr) {
      present(SFSafariViewController(url: url), animated: true)
    }
  }
}

final class FavCell: UITableViewCell {
  private let thumb = UIImageView()
  private let nameLabel = UILabel()
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    accessoryType = .disclosureIndicator
    thumb.translatesAutoresizingMaskIntoConstraints = false
    thumb.contentMode = .scaleAspectFill
    thumb.clipsToBounds = true
    thumb.layer.cornerRadius = 8
    nameLabel.numberOfLines = 2
    let stack = UIStackView(arrangedSubviews: [thumb, nameLabel])
    stack.spacing = 12
    stack.alignment = .center
    stack.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(stack)
    NSLayoutConstraint.activate([
      thumb.widthAnchor.constraint(equalToConstant: 60),
      thumb.heightAnchor.constraint(equalToConstant: 60),
      stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
      stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
      stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
    ])
  }
  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
  func configure(name: String, imageURL: String?) {
    nameLabel.text = name
    ImageLoader.shared.load(imageURL, into: thumb)
  }
}
