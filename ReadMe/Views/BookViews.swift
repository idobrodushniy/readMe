//
//  BookViews.swift
//  ReadMe
//
//  Created by Ilia on 28.11.2022.
//

import SwiftUI
import PhotosUI


extension Book {
    struct Image: View {
        let image: UIImage?
        let title: String
        var size: CGFloat?
        let cornerRadius: CGFloat
        
        var body: some View {
            if let image_ = image {
                SwiftUI.Image(uiImage: image_)
                    .resizable()
                    .scaledToFill()
                    .frame(width: size, height: size)
                    .cornerRadius(cornerRadius)
            } else {
                let symbol = SwiftUI.Image(title: title)
                ?? .init(systemName: "book")
                
                symbol
                    .resizable()
                    .scaledToFit()
                    .frame(width: size, height: size)
                    .font(Font.title.weight(.light))
                    .foregroundColor(.secondary.opacity(0.5))
            }
        }
    }
}

extension Book.Image {
    init(title: String){
        self.init(image: nil, title: title, cornerRadius: .init())
    }
}

extension Image {
    init?(title: String) {
        guard
            let character = title.first,
            case let symbolName = "\(character.lowercased()).square",
            UIImage(systemName: symbolName) != nil
        else {
            return nil
        }
        
        self.init(systemName: symbolName)
    }
}

struct TitleAndAuthorStack: View {
    let book: Book
    let titleFont: Font
    let authorFont: Font
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(book.title)
                .font(titleFont)
            Text(book.author)
                .font(authorFont)
                .foregroundColor(.secondary)
        }
    }
}

struct PhotoPicker: View {
    @State var selectedItem: PhotosPickerItem?
    @Binding var image: UIImage?
    @State var isTryingToDelete: Bool = false
    @Binding var title: String
    
    var body: some View {
        HStack{
            if image != nil {
                Spacer()
                Button("Delete image"){
                    isTryingToDelete = true
                }
            }
            Spacer()
            PhotosPicker(selection: $selectedItem, matching: .images){
                Text("Update image...")
                    .foregroundColor(.accentColor)
            }
            .onChange(of: selectedItem){ newItem in
                onSelectedPhoto(newItem: newItem)
            }
            Spacer()
        }
        .confirmationDialog(
            Text("Delete image for?"),
            isPresented: $isTryingToDelete
        ) {
            Button("Delete", role:.destructive) {
                image = nil
            }
        } message: {
            Text("Delete image for \(title)?")
        }
        .padding()
    }
    
    private func onSelectedPhoto(newItem: PhotosPickerItem?) {
        newItem?.loadTransferable(type: Data.self) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let success):
                    guard let data: Data = success  else {
                        return
                    }

                    guard let image_: UIImage = UIImage(data: data) else {
                        return
                    }
                    image = image_
                default:
                    return
                }
            }
        }
    }
}
