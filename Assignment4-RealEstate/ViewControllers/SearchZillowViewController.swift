//
//  SearchZillowViewController.swift
//  RealEstateFinder
//
//  Created by Daniel Park on 2025-08-03.
//

import UIKit
import CoreData

class SearchZillowViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var resultsTableView: UITableView!

    var properties: [ZillowProperty] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        resultsTableView.dataSource = self
        resultsTableView.delegate = self
        resultsTableView.allowsSelection = true

    }
    @IBAction func searchTapped(_ sender: UIButton) {
        let params = [
            "location": (locationTextField.text?.isEmpty == false) ? locationTextField.text! : "Toronto"
        ]

        ZillowService.shared.searchProperties(parameters: params) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let list):
                    self.properties = list
                    self.resultsTableView.reloadData()
                case .failure(let error):
                    self.showAlert(title: "Search Failed", message: error.localizedDescription)
                }
            }
        }
    }

    @IBAction func viewFavoritesTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "toFavorites", sender: self)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        properties.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PropertyCell", for: indexPath)
        let item = properties[indexPath.row]
        cell.textLabel?.numberOfLines = 2
        cell.textLabel?.text = item.address ?? "No address"
        cell.selectionStyle = .default
        return cell
    }

    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let p = properties[indexPath.row]
        let price = p.price.map { "$" + NumberFormatter.localizedString(from: NSNumber(value: $0), number: .decimal) } ?? "—"
        let beds  = p.bedrooms.map { "\($0) bd" } ?? "—"
        let baths = p.bathrooms.map { String(format: "%.1f ba", $0) } ?? "—"

        let a = UIAlertController(
            title: "Selected",
            message: """
            \(p.address ?? "No address")
            • \(price) • \(beds) • \(baths)
            """,
            preferredStyle: .alert
        )

        let favTitle = isAlreadyFavorited(p) ? "Already in Favorites" : "Add to Favorites"
        a.addAction(UIAlertAction(title: favTitle, style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            if self.isAlreadyFavorited(p) {
                self.toast("Already in Favorites")
            } else {
                self.saveFavorite(for: p)
                self.toast("Added to Favorites")
            }
        }))

        a.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(a, animated: true)
    }

    private func saveFavorite(for item: ZillowProperty) {
        let ctx = CoreDataManager.shared.context
        let prop = Property(context: ctx)
        prop.id = item.zpid ?? item.id ?? UUID().uuidString
        prop.address = item.address
        prop.price = item.price ?? 0
        prop.bedrooms = Int16(item.bedrooms ?? 0)
        prop.bathrooms = Int16((item.bathrooms ?? 0).rounded())
        prop.imageURL = item.imgSrc
        prop.isFavorite = true
        CoreDataManager.shared.save()
    }

    private func isAlreadyFavorited(_ item: ZillowProperty) -> Bool {
        let ctx = CoreDataManager.shared.context
        let req: NSFetchRequest<Property> = Property.fetchRequest()
        let pid = item.zpid ?? item.id ?? ""
        if pid.isEmpty { return false }
        req.fetchLimit = 1
        req.predicate = NSPredicate(format: "id == %@", pid)
        return ((try? ctx.fetch(req))?.first) != nil
    }

    private func showAlert(title: String, message: String) {
        let a = UIAlertController(title: title, message: message, preferredStyle: .alert)
        a.addAction(UIAlertAction(title: "OK", style: .default))
        present(a, animated: true)
    }

    private func toast(_ text: String) {
        let l = UILabel()
        l.text = text
        l.textAlignment = .center
        l.numberOfLines = 0
        l.backgroundColor = UIColor.black.withAlphaComponent(0.65)
        l.textColor = .white
        l.layer.cornerRadius = 8
        l.layer.masksToBounds = true
        l.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(l)
        NSLayoutConstraint.activate([
            l.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            l.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80),
            l.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 24),
            l.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -24)
        ])
        UIView.animate(withDuration: 0.25, delay: 1.0, options: []) {
            l.alpha = 0
        } completion: { _ in l.removeFromSuperview() }
    }
}
