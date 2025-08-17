//
//  BookDetailView.swift
//  ExamPart2
//
//  Created by Daniel Park on 2025-08-12.
//

import SwiftUI

struct BookDetailView: View {
    @Binding var book: Book

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(book.title)
                    .font(.title)
                    .bold()

                Text("by \(book.author)")
                    .font(.title3)
                    .foregroundStyle(.secondary)

                Text(book.description)
                    .font(.body)
                    .fixedSize(horizontal: false, vertical: true)

                Toggle(isOn: $book.isFavorite) {
                    Label("Mark as Favorite", systemImage: book.isFavorite ? "star.fill" : "star")
                }
                .padding(.top, 8)
            }
            .padding()
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
