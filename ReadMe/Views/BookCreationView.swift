//
//  BookCreationView.swift
//  ReadMe
//
//  Created by Ilia on 10.12.2022.
//

import Foundation
import SwiftUI

struct BookCreationView: View {
    @State var title: String = ""
    @State var author: String = ""
    @State var review: String = ""
    @State var image: UIImage?
    
    var body: some View{
        VStack{
            VStack(alignment: .leading) {
                TextField("Title", text:$title)
                    .padding(.bottom)
                TextField("Author", text: $author)
                    .padding(.bottom)
                Divider()
                    .padding(.vertical)
                TextField("Review...", text: $review)
                Divider()
                    .padding(.vertical)
                Book.Image(image: image, title: title, cornerRadius: 16)
                    .scaledToFit()
            }
            PhotoPicker(image: $image, title: $title)
            Spacer()
        }
        .padding()
    }
}

struct BookCreationView_Previews: PreviewProvider {
    static var previews: some View {
        BookCreationView()
    }
}
