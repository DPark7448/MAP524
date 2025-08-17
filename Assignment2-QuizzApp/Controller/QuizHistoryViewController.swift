//
//  QuizHistoryViewController.swift
//  QuizApp
//
//  Created by Daniel Park on 2025-07-03.
//

import UIKit

class QuizHistoryViewController: UIViewController {
    
   
    @IBOutlet weak var textView: UITextView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        var text = "Quiz History:\n\n"
        let grouped = Dictionary(grouping: ResultsViewController.history, by: { $0 })
        for (type, list) in grouped {
            text += "\(type.rawValue) - \(list.count) times\n"
        }
        textView.text = text
    }
}
