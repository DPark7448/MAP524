//
//  ResultsViewController.swift
//  QuizApp
//
//  Created by Daniel Park on 2025-07-03.
//

import UIKit

class ResultsViewController: UIViewController {
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var definitionLabel: UILabel!
    
    var result: PersonalityType?
    static var history: [PersonalityType] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let result = result {
            resultLabel.text = "You are a \(result.rawValue)"
            definitionLabel.text = result.definition
            ResultsViewController.history.append(result)
        }
    }



}

