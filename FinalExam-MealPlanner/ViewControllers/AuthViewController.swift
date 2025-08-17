//
//  AuthViewController.swift
//  MealPlanner
//
//  Created by Daniel Park on 2025-08-11.
//

import UIKit
import CoreData

final class AuthViewController: UIViewController {
  private let titleLabel = UILabel()
  private let usernameField = UITextField()
  private let passwordField = UITextField()
  private let modeControl = UISegmentedControl(items: ["Login", "Signup"])
  private let goButton = UIButton(type: .system)

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    layout()
  }

  private func layout() {
    titleLabel.text = "Meal Planner"
    titleLabel.font = .boldSystemFont(ofSize: 28)
    usernameField.placeholder = "Username"
    usernameField.borderStyle = .roundedRect
    passwordField.placeholder = "Password"
    passwordField.borderStyle = .roundedRect
    passwordField.isSecureTextEntry = true
    modeControl.selectedSegmentIndex = 0
    goButton.setTitle("Continue", for: .normal)
    goButton.addTarget(self, action: #selector(handleGo), for: .touchUpInside)

    let stack = UIStackView(arrangedSubviews: [
      titleLabel, usernameField, passwordField, modeControl, goButton
    ])
    stack.axis = .vertical
    stack.spacing = 12
    stack.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(stack)
    NSLayoutConstraint.activate([
      stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
      stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
    ])
  }

  @objc private func handleGo() {
    let ctx = CoreDataStack.shared.context
    let username = usernameField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    let password = passwordField.text ?? ""
    guard !username.isEmpty, !password.isEmpty else { alert("Please fill both fields"); return }

    if modeControl.selectedSegmentIndex == 0 {
      let req: NSFetchRequest<User> = User.fetchRequest()
      req.predicate = NSPredicate(format: "username == %@ AND password == %@", username, password)
      do {
        if let user = try ctx.fetch(req).first {
          presentMain(for: user)
        } else {
          alert("Invalid credentials")
        }
      } catch {
        alert("Login error: \(error.localizedDescription)")
      }
    } else {
      let user = User(context: ctx)
      user.username = username
      user.password = password
      CoreDataStack.shared.saveContext()
      presentMain(for: user)
    }
  }

  private func presentMain(for user: User) {
    let tab = MainTabBarController(currentUser: user)
    tab.modalPresentationStyle = .fullScreen
    present(tab, animated: true)
  }

  private func alert(_ msg: String) {
    let a = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
    a.addAction(UIAlertAction(title: "OK", style: .default))
    present(a, animated: true)
  }
}
