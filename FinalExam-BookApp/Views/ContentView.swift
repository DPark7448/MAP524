//
//  ContentView.swift
//  ExamPart2
//
//  Created by Daniel Park on 2025-08-12.
//

import SwiftUI

struct ContentView: View {
    @State private var books: [Book] = sampleBooks()

    var body: some View {
        NavigationStack {
            List {
                ForEach(Genre.allCases) { genre in
                    let indices = books.indices.filter { books[$0].genre == genre }
                    if !indices.isEmpty {
                        Section(genre.rawValue) {
                            ForEach(indices, id: \.self) { idx in
                                NavigationLink {
                                    BookDetailView(book: $books[idx])
                                } label: {
                                    BookRow(book: books[idx])
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Books")
        }
    }
}
