//
//  LoginViewController.swift
//  RealEstateFinder
//
//  Created by Daniel Park on 2025-08-03.
//

import UIKit
import CoreData

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    @IBAction func loginTapped(_ sender: UIButton) {
        let ctx = CoreDataManager.shared.context
        let req: NSFetchRequest<User> = User.fetchRequest()
        req.predicate = NSPredicate(format: "email == %@ AND password == %@", emailTextField.text ?? "", passwordTextField.text ?? "")
        if let result = try? ctx.fetch(req), !result.isEmpty {
            performSegue(withIdentifier: "toSearch", sender: self)
        } else { showAlert("Invalid credentials") }
    }

    @IBAction func registerTapped(_ sender: UIButton) { performSegue(withIdentifier: "toRegister", sender: self) }

    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
