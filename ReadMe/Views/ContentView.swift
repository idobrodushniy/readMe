//
//  ContentView.swift
//  ReadMe
//
//  Created by Ilia on 28.11.2022.
//

import SwiftUI

extension View{
    func alignedItem() -> some View{
        return self.alignmentGuide(.listRowSeparatorLeading){ _ in
            return 0
        }
    }
}

struct ContentView: View {
    @State var library = Library()
    @State var isAddingNewBookSheetDisplayed = false
    
    var body: some View {
        
        NavigationStack {
            VStack{
                List {
                    Button {
                        isAddingNewBookSheetDisplayed = true
                    } label: {
                        Spacer()
                        VStack(spacing: 6) {
                            Image(systemName: "book.circle")
                                .font(.system(size: 60))
                            Text("Add New Book")
                                .font(.title2)
                        }
                        Spacer()
                    }
                    .buttonStyle(.borderless)
                    .padding(.vertical, 8)
                    .alignedItem()
                    .sheet(isPresented: $isAddingNewBookSheetDisplayed){
                        BookCreationView()
                    }
                    
                    ForEach(library.sortedBooks) { book in
                        BookRow(book: book, image: $library.booksImages[book])
                            .alignedItem()
                    }
                
                }
            }
            .navigationTitle("My Library")
        }
        .listStyle(PlainListStyle())
        
    }
}

struct BookRow: View {
    @ObservedObject var book: Book
    @Binding var image: UIImage?
    
    var body: some View {
        NavigationLink(destination: BookDetailView(book: book, image: $image)) {
            HStack {
                Book.Image(image: image, title: book.title, size: 80, cornerRadius: 12)
                VStack(alignment: .leading) {
                    TitleAndAuthorStack(book: book, titleFont: .title2, authorFont: .title3)
                        .lineLimit(1)
                    
                    if !book.microReview.isEmpty {
                        Spacer()
                        Text(book.microReview)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                }
                .padding(.vertical)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
