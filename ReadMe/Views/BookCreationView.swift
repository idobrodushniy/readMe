//
//  BookCreationView.swift
//  ReadMe
//
//  Created by Ilia on 10.12.2022.
//

import Foundation
import SwiftUI

struct BookCreationView: View {
    @ObservedObject var book: Book = Book(title:"", author: "", microReview: "")
    @EnvironmentObject var library: Library
    @State var image: UIImage?
    @Environment(\.dismiss) var dismiss
    
    var body: some View{
        NavigationStack{
            VStack(alignment: .leading){
                Text("Got a new book?")
                    .navigationBarTitleDisplayMode(.inline)
                    .font(.title)
                    .bold()
                VStack(alignment: .leading) {
                    TextField("Title", text:$book.title)
                        .padding(.bottom)
                    TextField("Author", text: $book.author)
                        .padding(.bottom)
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
            }.ignoresSafeArea(.keyboard)
            
            .toolbar {
                ToolbarItem(placement: .status) {
                    Button("Add to Library") {
                        library.addNewNook(book: book, image: image)
                        dismiss()
                    }
                }
            }
        }
        .padding()
    }
}

struct BookCreationView_Previews: PreviewProvider {
    static var previews: some View {
        BookCreationView()
            .environmentObject(Library())
        
    }
}
