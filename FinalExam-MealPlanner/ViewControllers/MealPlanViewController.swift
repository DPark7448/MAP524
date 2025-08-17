//
//  MealPlanViewController.swift
//  MealPlanner
//
//  Created by Daniel Park on 2025-08-11.
//

import UIKit
import SafariServices
import CoreData

final class MealPlanViewController: UITableViewController {
  private let currentUser: User
  private var dates: [Date] = []
  private var entriesByDaySlot: [Date: [String: PlanEntry]] = [:] 

  init(currentUser: User) { self.currentUser = currentUser; super.init(style: .insetGrouped) }
  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Meal Plan"
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    buildDates()
    reloadEntries()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    reloadEntries()
  }

  private func buildDates() {
    let start = Calendar.current.startOfDay(for: Date())
    dates = (0..<7).compactMap { Calendar.current.date(byAdding: .day, value: $0, to: start) }
  }

  private func reloadEntries() {
    entriesByDaySlot.removeAll()
    let ctx = CoreDataStack.shared.context
    let req: NSFetchRequest<PlanEntry> = PlanEntry.fetchRequest()
    let end = Calendar.current.date(byAdding: .day, value: 7, to: Calendar.current.startOfDay(for: Date()))!
    req.predicate = NSPredicate(format: "owner == %@ AND date >= %@ AND date < %@", currentUser, Calendar.current.startOfDay(for: Date()) as NSDate, end as NSDate)
    do {
      let items = try ctx.fetch(req)
      for i in items {
        let day = Calendar.current.startOfDay(for: i.date)
        var slots = entriesByDaySlot[day] ?? [:]
        slots[i.slot] = i
        entriesByDaySlot[day] = slots
      }
      tableView.reloadData()
    } catch { print(error) }
  }

  override func numberOfSections(in tableView: UITableView) -> Int { dates.count }
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    let d = dates[section]
    let f = DateFormatter(); f.dateStyle = .full
    return f.string(from: d)
  }
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 3 }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    let day = dates[indexPath.section]
    let slot = slotName(for: indexPath.row)
    if let entry = entriesByDaySlot[day]?[slot] {
      var conf = UIListContentConfiguration.valueCell()
      conf.text = "\(slot): \(entry.name)"
      conf.secondaryText = "Open recipe"
      cell.contentConfiguration = conf
      cell.accessoryType = .disclosureIndicator
    } else {
      var conf = UIListContentConfiguration.subtitleCell()
      conf.text = slot
      conf.secondaryText = "Empty"
      cell.contentConfiguration = conf
      cell.accessoryType = .none
    }
    return cell
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let day = dates[indexPath.section]
    let slot = slotName(for: indexPath.row)
    if let entry = entriesByDaySlot[day]?[slot], let urlStr = entry.recipeURL, let url = URL(string: urlStr) {
      present(SFSafariViewController(url: url), animated: true)
    } else {
      let search = SearchViewController(currentUser: currentUser) { [weak self] recipe in
        guard let self = self else { return }
        let ctx = CoreDataStack.shared.context
        let p = PlanEntry(context: ctx)
        p.date = day
        p.slot = slot
        p.mealId = Int64(recipe.id)
        p.name = recipe.name
        p.imageURL = recipe.thumbnail_url
        p.recipeURL = recipe.url
        p.owner = self.currentUser
        CoreDataStack.shared.saveContext()
        self.reloadEntries()
        self.navigationController?.popViewController(animated: true)
      }
      navigationController?.pushViewController(search, animated: true)
    }
  }

  private func slotName(for row: Int) -> String { ["Breakfast", "Lunch", "Dinner"][row] }
}
