//
//  MealDetailsViewController.swift
//  MealPlanner
//
//  Created by Daniel Park on 2025-08-11.
//

import UIKit
import SafariServices

final class MealDetailsViewController: UIViewController {
  private let currentUser: User
  private let recipe: Recipe

  private let imageView = UIImageView()
  private let titleLabel = UILabel()
  private let timeLabel = UILabel()
  private let tagsLabel = UILabel()
  private let openButton = UIButton(type: .system)
  private let favButton = UIButton(type: .system)
  private let planButton = UIButton(type: .system)

  init(currentUser: User, recipe: Recipe) { self.currentUser = currentUser; self.recipe = recipe; super.init(nibName: nil, bundle: nil) }
  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    title = "Details"

    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.layer.cornerRadius = 12
    imageView.heightAnchor.constraint(equalToConstant: 220).isActive = true

    titleLabel.font = .boldSystemFont(ofSize: 22)
    timeLabel.textColor = .secondaryLabel
    tagsLabel.numberOfLines = 0
    tagsLabel.textColor = .secondaryLabel

    openButton.setTitle("Open Recipe", for: .normal)
    favButton.setTitle("Save Favorite", for: .normal)
    planButton.setTitle("Add to Meal Plan", for: .normal)

    openButton.addTarget(self, action: #selector(openInSafari), for: .touchUpInside)
    favButton.addTarget(self, action: #selector(saveFavorite), for: .touchUpInside)
    planButton.addTarget(self, action: #selector(addToPlan), for: .touchUpInside)

    let buttons = UIStackView(arrangedSubviews: [openButton, favButton, planButton])
    buttons.axis = .vertical
    buttons.spacing = 8

    let stack = UIStackView(arrangedSubviews: [imageView, titleLabel, timeLabel, tagsLabel, buttons])
    stack.axis = .vertical
    stack.spacing = 12
    stack.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(stack)
    NSLayoutConstraint.activate([
      stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
      stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
    ])

    ImageLoader.shared.load(recipe.thumbnail_url, into: imageView)
    titleLabel.text = recipe.name
    if let mins = recipe.times?.total_time?.minutes { timeLabel.text = "Total time: \(mins) min" }
    tagsLabel.text = recipe.tags?.joined(separator: ", ")
  }

  @objc private func openInSafari() {
    guard let urlStr = recipe.url, let url = URL(string: urlStr) else { return }
    present(SFSafariViewController(url: url), animated: true)
  }

  @objc private func saveFavorite() {
    let ctx = CoreDataStack.shared.context
    let f = Favorite(context: ctx)
    f.mealId = Int64(recipe.id)
    f.name = recipe.name
    f.imageURL = recipe.thumbnail_url
    f.recipeURL = recipe.url
    if let tags = recipe.tags, let data = try? JSONEncoder().encode(tags) { f.tagsJSON = String(data: data, encoding: .utf8) }
    f.owner = currentUser
    CoreDataStack.shared.saveContext()
    alert("Added to Favorites")
  }

  @objc private func addToPlan() {
    let sheet = UIAlertController(title: "Add to Meal Plan", message: "Choose date & slot", preferredStyle: .actionSheet)
    let slots = ["Breakfast", "Lunch", "Dinner"]
    for s in slots {
      sheet.addAction(UIAlertAction(title: s, style: .default, handler: { [weak self] _ in self?.promptDate(slot: s) }))
    }
    sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    present(sheet, animated: true)
  }

  private func promptDate(slot: String) {
    let picker = UIDatePicker(); picker.datePickerMode = .date; picker.preferredDatePickerStyle = .wheels
    let vc = UIViewController(); vc.preferredContentSize = CGSize(width: 250, height: 300)
    vc.view.addSubview(picker)
    picker.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      picker.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor),
      picker.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor)
    ])
    let alert = UIAlertController(title: "Select Date", message: nil, preferredStyle: .alert)
    alert.setValue(vc, forKey: "contentViewController")
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { _ in
      let ctx = CoreDataStack.shared.context
      let p = PlanEntry(context: ctx)
      p.date = Calendar.current.startOfDay(for: picker.date)
      p.slot = slot
      p.mealId = Int64(self.recipe.id)
      p.name = self.recipe.name
      p.imageURL = self.recipe.thumbnail_url
      p.recipeURL = self.recipe.url
      p.owner = self.currentUser
      CoreDataStack.shared.saveContext()
      self.alert("Added to \(slot)")
    }))
    present(alert, animated: true)
  }

  private func alert(_ msg: String) {
    let a = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
    a.addAction(UIAlertAction(title: "OK", style: .default))
    present(a, animated: true)
  }
}
