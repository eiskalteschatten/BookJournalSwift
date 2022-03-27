//
//  MacNewBookStep6.swift
//  BookJournal (macOS)
//
//  Created by Alex Seifert on 21.03.22.
//

import SwiftUI

struct MacNewBookStep6: View {
    @ObservedObject var bookModel: BookModel
    
    var body: some View {
        VStack {
            MacNewBookStepTitle("Genres")
            
            // Genres
            GenresSearchList(selectedItems: $bookModel.genres)
        }
    }
}

struct MacNewBookStep6_Previews: PreviewProvider {
    @StateObject static var bookModel = BookModel()
    
    static var previews: some View {
        MacNewBookStep6(bookModel: bookModel)
            .frame(height: 500.0)
    }
}
