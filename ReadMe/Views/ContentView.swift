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
    @EnvironmentObject var library: Library
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
                            .ignoresSafeArea(.keyboard)
                    }
                    
                    ForEach(SectionOption.allCases, id: \.self) {
                        SectionView(section: $0)
                    }
                }
                .listStyle(.insetGrouped)
                .toolbar(content: EditButton.init)
            }
            .navigationTitle("My Library")
        }
        
    }
}

private struct BookRow: View {
    @ObservedObject var book: Book
    @EnvironmentObject var library: Library
    
    var body: some View {
        NavigationLink(destination: BookDetailView(book: book).ignoresSafeArea(.keyboard)) {
            HStack {
                Book.Image(image: library.booksImages[book], title: book.title, size: 80, cornerRadius: 12)
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

private struct SectionView: View {
    let section: SectionOption
    @EnvironmentObject var library: Library
    var title: String {
        switch section {
        case .readMe:
            return "Reading"
        case .finished:
            return "Finished"
        }
    }
    
    var body: some View {
        if let books = library.sortedBooks[section]{
            Section {
                ForEach(books) { book in
                    BookRow(book: book)
                        .swipeActions(edge: .leading){
                            Button {
                                withAnimation{
                                    book.readMe.toggle()
                                    library.sortBooks()
                                }
                            } label: {
                                book.readMe
                                ? Label("Mark finished", systemImage: "bookmark.slash")
                                : Label("Unmark finished", systemImage: "bookmark")
                            }
                            .tint(.accentColor)
                        }
                        .swipeActions(edge: .trailing){
                            Button(role: .destructive){
                                guard let index = books.firstIndex(where: {$0.id == book.id}) else {return}
                                
                                withAnimation{
                                    library.deleteBook(atOffsets: .init(integer:index), section: section)
                                }
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }
                .onDelete{ indexSet in
                    library.deleteBook(atOffsets: indexSet, section: section)
                }
                .onMove { indexes, newOffset in
                    library.moveBooks(oldOffsets: indexes, newOffset: newOffset, section: section)
                }
                .labelStyle(.iconOnly)
            } header: {
                ZStack{
                    Image("BookTexture")
                        .resizable()
                        .scaledToFit()
                    Text(title)
                        .font(.custom("American Typewriter", size:24))
                        .foregroundColor(.primary)
                        .textCase(.uppercase)
                }
                .listRowInsets(.init())
                .cornerRadius(5)
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Library())
    }
}
