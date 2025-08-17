//
//  RegisterViewController.swift
//  RealEstateFinder
//
//  Created by Daniel Park on 2025-08-03.
//

import UIKit

class RegisterViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    @IBAction func registerButtonTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty, let pass = passwordTextField.text, !pass.isEmpty else { return }
        let ctx = CoreDataManager.shared.context
        let user = User(context: ctx)
        user.email = email
        user.password = pass
        CoreDataManager.shared.save()
        performSegue(withIdentifier: "toSearch", sender: self)
    }
}
