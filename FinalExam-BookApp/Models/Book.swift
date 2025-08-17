//
//  Book.swift
//  ExamPart2
//
//  Created by Daniel Park on 2025-08-12.
//

import Foundation

enum Genre: String, CaseIterable, Identifiable, Hashable {
    case fiction = "Fiction"
    case nonFiction = "Non-Fiction"
    case sciFi = "Sci-Fi"

    var id: String { rawValue }
}

struct Book: Identifiable, Hashable {
    let id = UUID()
    var title: String
    var author: String
    var description: String
    var genre: Genre
    var isFavorite: Bool = false
}
