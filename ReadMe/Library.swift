//
//  Library.swift
//  ReadMe
//
//  Created by Ilia on 28.11.2022.
//
import SwiftUI

enum SectionOption: CaseIterable{
    case readMe
    case finished
}
class Library: ObservableObject {
    
    var sortedBooks: [SectionOption:[Book]] {
        get {
            let groupedBooks = Dictionary(grouping: booksCache, by: \.readMe)
            return Dictionary(uniqueKeysWithValues: groupedBooks.map{
                (($0.key ? .readMe : .finished), $0.value)
            })
        }
        set {
            booksCache = newValue
                .sorted{$1.key == .finished}
                .flatMap{$0.value}
        }
    }
    
    func sortBooks() {
        booksCache = sortedBooks
            .sorted{$1.key == .finished}
            .flatMap{$0.value}
        objectWillChange.send()
    }
    
    func addNewNook(book: Book, image: UIImage?){
        booksCache.insert(book, at: 0)
        if image != nil {
            updateImage(book: book, image: image)
        }
    }
    
    func deleteBook(atOffsets offsets: IndexSet, section: SectionOption){
        let booksBeforeDeletion = booksCache
        
        sortedBooks[section]?.remove(atOffsets: offsets)
        
        for change in booksCache.difference(from: booksBeforeDeletion){
            if case .remove(_, let deletedBook, _) = change {
                booksImages[deletedBook] = nil
            }
        }
    }
    func moveBooks(oldOffsets: IndexSet, newOffset: Int, section: SectionOption) {
        sortedBooks[section]?.move(fromOffsets: oldOffsets, toOffset: newOffset)
    }
    
    func updateImage(book: Book, image: UIImage?){
        booksImages[book] = image
    }
    
    /// An in-memory cache of the manually-sorted books.
    @Published private var booksCache: [Book] = [
        .init(title: "Ein Neues Land", author: "Shaun Tan"),
        .init(title: "Bosch", author: "Laurinda Dixon", microReview: "Earthily Delightful."),
        .init(title: "Dare to Lead", author: "Brené Brown"),
        .init(title: "Blasting for Optimum Health Recipe Book", author: "NutriBullet"),
        .init(title: "Drinking with the Saints", author: "Michael P. Foley", microReview: "One of Ozma's favorites! 😻"),
        .init(title: "A Guide to Tea", author: "Adagio Teas"),
        .init(title: "The Life and Complete Work of Francisco Goya", author: "P. Gassier & J Wilson", microReview: "Book too large for a micro-review!"),
        .init(title: "Lady Cottington's Pressed Fairy Book", author: "Lady Cottington"),
        .init(title: "How to Draw Cats", author: "Janet Rancan", readMe: false),
        .init(title: "Drawing People", author: "Barbara Bradley", readMe: false),
        .init(title: "What to Say When You Talk to Yourself", author: "Shad Helmstetter")
    ]
    
    @Published var booksImages: [Book: UIImage] = [:]
}
