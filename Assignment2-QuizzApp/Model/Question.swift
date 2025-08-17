//
//  Question.swift
//  QuizApp
//
//  Created by Daniel Park on 2025-07-04.
//

enum ResponseType {
    case single, multiple, ranged
}

struct Question {
    let text: String
    let type: ResponseType
    let answers: [Answer]
}
