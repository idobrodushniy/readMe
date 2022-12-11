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
    @Binding var image: UIImage?
    
    var body: some View {
        return VStack{
            VStack(alignment: .leading) {
                HStack {
                    Button {
                        book.readMe.toggle()
                    } label: {
                        Image(systemName: book.readMe ? "bookmark.fill":"bookmark")
                            .font(.system(size:48, weight:.light))
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
                Book.Image(image: image, title: book.title, cornerRadius: 16)
                    .scaledToFit()
            }
            PhotoPicker(image: $image, title: $book.title)
            Spacer()
        }
        .padding()
    }
}


struct ExtraPreviewTestView: View {
    @State var image: UIImage?
    
    var body: some View {
        BookDetailView(book: Book(title: "Ein Neues Land", author: "Shaun Tan", microReview: "Delightful!"), image: $image)
    }
}

struct BookDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ExtraPreviewTestView()
    }
}
