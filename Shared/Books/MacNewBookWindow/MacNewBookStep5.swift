//
//  MacNewBookStep5.swift
//  BookJournal (macOS)
//
//  Created by Alex Seifert on 21.03.22.
//

import SwiftUI

struct MacNewBookStep5: View {
    @ObservedObject var bookModel: BookModel
    
    var body: some View {
        VStack {
            MacNewBookStepTitle("Genres")
            
            // Genres
            GenresSearchList(selectedItems: $bookModel.genres)
        }
    }
}

struct MacNewBookStep5_Previews: PreviewProvider {
    @StateObject static var bookModel = BookModel()
    
    static var previews: some View {
        MacNewBookStep5(bookModel: bookModel)
            .frame(height: 500.0)
    }
}
