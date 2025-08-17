//
//  SampleData.swift
//  ExamPart2
//
//  Created by Daniel Park on 2025-08-12.
//

import Foundation

func sampleBooks() -> [Book] {
    [
        Book(title: "A Court of Thorns and Roses",
             author: "ASarah J. Maas",
             description: "When nineteen-year-old huntress Feyre kills a wolf in the woods, a terrifying creature arrives to demand retribution. Dragged to a treacherous magical land she knows about...",
             genre: .fiction),
        Book(title: "Everything I Know About Love: A Memoir",
             author: "Dolly Alderton",
             description: "When it comes to the trials and triumphs of becoming an adult, writer Dolly Alderton has seen and tried it all. In her memoir, she vividly recounts falling in love, finding a job, getting drunk, getting dumped, and that absolutely no one can ever compare to her best girlfriends. Everything I Know About Love is about bad dates, good friends and—above all else— realizing that you are enough.",
             genre: .nonFiction, isFavorite: true),
        Book(title: "Funny Story",
             author: "Emily Henry",
             description: "A shimmering, joyful novel about a pair of opposites with the wrong thing in common, from #1 New York Times bestselling author Emily Henry.",
             genre: .nonFiction),
        Book(title: "The Heaven & Earth Grocery Store: A Novel",
             author: "James McBride",
             description: "A murder mystery locked inside a Great American Novel.",
             genre: .fiction),
        Book(title: "The Bible",
             author: "God",
             description: "Follow Jesus in his journey to englighten the world",
             genre: .sciFi, isFavorite: true),
        Book(title: "Harry Potter",
             author: "J.K.Rowling",
             description: "Wizards, magic, and explosions!",
             genre: .fiction)
    ]
}
