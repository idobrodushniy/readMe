//
//  BookDetailView.swift
//  ReadMe
//
//  Created by Ilia on 29.11.2022.
//

import SwiftUI
import PhotosUI
struct BookDetailView: View {
    @ObservedObject var book: Book
    @EnvironmentObject var library: Library
    
    var body: some View {
        VStack{
            VStack(alignment: .leading) {
                HStack {
                    Button {
                        book.readMe.toggle()
                    } label: {
                        Image(systemName: book.readMe ? "bookmark.fill":"bookmark")
                            .font(.system(size:48, weight:.light))
                    }.onDisappear{
                        withAnimation{
                            library.sortBooks()
                        }
                    }
                    
                    TitleAndAuthorStack(
                        book: book,
                        titleFont: .title,
                        authorFont: .title2
                    )
                }
                Divider()
                    .padding(.vertical)
                TextField("Review...", text: $book.microReview)
                Divider()
                    .padding(.vertical)
                Book.Image(image: library.booksImages[book], title: book.title, cornerRadius: 16)
                    .scaledToFit()
            }
            PhotoPicker(image: $library.booksImages[book], title: $book.title)
            Spacer()
        }
        .padding()
    }
}


struct ExtraPreviewTestView: View {
    @EnvironmentObject var library: Library
    
    var body: some View {
        BookDetailView(book: Book(title: "Ein Neues Land", author: "Shaun Tan", microReview: "Delightful!"))
    }
}

struct BookDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ExtraPreviewTestView()
            .environmentObject(Library())
    }
}
