//
//  QuizView.swift
//  QuizApp
//
//  Created by Daniel Park on 2025-07-03.
//

import UIKit

class QuizViewController: UIViewController {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    private var nextButton: UIBarButtonItem!
    
    var questions: [Question] = []
    var currentQuestionIndex = 0
    var answersChosen: [Answer] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate   = self
        tableView.dataSource = self
        
        nextButton = UIBarButtonItem(
            title: "Next",
            style: .plain,
            target: self,
            action: #selector(nextButtonTapped)
        )
        navigationItem.rightBarButtonItem = nextButton
        
        loadQuestions()
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetQuiz()
    }
    
    func resetQuiz() {
        answersChosen.removeAll()
        currentQuestionIndex = 0
        updateUI()
    }
    
    func loadQuestions() {
        questions = [
            Question(
                text: "What’s your favorite activity?",
                type: .single,
                answers: [
                    Answer(text: "Swimming", type: .dolphin),
                    Answer(text: "Hunting",  type: .lion),
                    Answer(text: "Sleeping", type: .bear),
                    Answer(text: "Climbing", type: .cat)
                ]
            ),
            Question(
                text: "Pick some traits",
                type: .multiple,
                answers: [
                    Answer(text: "Brave",  type: .lion),
                    Answer(text: "Smart",  type: .dolphin),
                    Answer(text: "Chill",  type: .cat),
                    Answer(text: "Strong", type: .bear)
                ]
            )
        ]
    }
    
    func updateUI() {
        let currentQuestion = questions[currentQuestionIndex]
        questionLabel.text = currentQuestion.text
        tableView.reloadData()
        
        let isMultiple = (currentQuestion.type == .multiple)
        tableView.allowsMultipleSelection = isMultiple
        
        nextButton.isHidden  = !isMultiple
        nextButton.isEnabled = false
    }
    
    @objc private func nextButtonTapped() {
        guard let selectedRows = tableView.indexPathsForSelectedRows else { return }
        let currentAnswers = questions[currentQuestionIndex].answers
        for ip in selectedRows {
            answersChosen.append(currentAnswers[ip.row])
        }
        goToNextQuestion()
    }
    
    func goToNextQuestion() {
        currentQuestionIndex += 1
        if currentQuestionIndex < questions.count {
            updateUI()
        } else {
            performSegue(withIdentifier: "ShowCustomQuestions", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowCustomQuestions",
           let destVC = segue.destination as? CustomQuestionsViewController {
            destVC.answersChosen = answersChosen
        }
    }
}

extension QuizViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tv: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions[currentQuestionIndex].answers.count
    }
    
    func tableView(_ tv: UITableView, cellForRowAt indexPath: IndexPath)
      -> UITableViewCell
    {
        let cell = tv.dequeueReusableCell(
            withIdentifier: "AnswerCell", for: indexPath
        ) as! AnswerCell
        let answer = questions[currentQuestionIndex].answers[indexPath.row]
        cell.answerLabel.text = answer.text
        return cell
    }
    
    func tableView(_ tv: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentQuestion = questions[currentQuestionIndex]
        switch currentQuestion.type {
        case .single, .ranged:
            answersChosen.append(currentQuestion.answers[indexPath.row])
            goToNextQuestion()
            
        case .multiple:
            nextButton.isEnabled = true
        }
    }
    
    func tableView(_ tv: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tv.indexPathsForSelectedRows?.isEmpty ?? true {
            nextButton.isEnabled = false
        }
    }
}
