//
//  PersonalityType.swift
//  QuizApp
//
//  Created by Daniel Park on 2025-07-04.
//

enum PersonalityType: String {
    case lion = "🦁"
    case dolphin = "🐬"
    case bear = "🐻"
    case cat = "🐱"
    
    var definition: String {
        switch self {
        case .lion:
            return "You are bold and brave!"
        case .dolphin:
            return "You are smart and playful!"
        case .bear:
            return "You are strong and steady!"
        case .cat:
            return "You are curious and chill!"
        }
    }
}
