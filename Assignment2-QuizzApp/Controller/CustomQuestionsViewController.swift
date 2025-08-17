//
//  CustomQuestionsViewController.swift
//  QuizApp
//
//  Created by Daniel Park on 2025-07-03.
//

import UIKit

class CustomQuestionsViewController: UIViewController {
    
    var answersChosen: [Answer] = []
    var result: PersonalityType?
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var mealLabel: UILabel!

    @IBOutlet weak var bigOrSmallControl: UISegmentedControl!
    @IBOutlet weak var mealPicker: UIPickerView!
    
    let meals = ["Breakfast", "Lunch", "Dinner"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionLabel.text = "Do you like small or big animals?"
        mealLabel.text = "What is your favourite meal?"
        mealPicker.dataSource = self
        mealPicker.delegate = self
    }
    
    @IBAction func submitTapped(_ sender: UIButton) {
        if bigOrSmallControl.selectedSegmentIndex == 0 {
            answersChosen.append(Answer(text: "Big", type: .bear))
        } else {
            answersChosen.append(Answer(text: "Small", type: .cat))
        }

        calculateResult()
        performSegue(withIdentifier: "ShowResults", sender: nil)
    }
    
    func calculateResult() {
        let types = answersChosen.map { $0.type }
        let frequency = types.reduce(into: [:]) { counts, type in
            counts[type, default: 0] += 1
        }
        result = frequency.max { $0.value < $1.value }?.key
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowResults" {
            let dest = segue.destination as! ResultsViewController
            dest.result = result
        }
    }
}

extension CustomQuestionsViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { meals.count }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        meals[row]
    }
}
