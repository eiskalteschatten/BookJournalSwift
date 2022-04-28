//
//  MacEditBookStep6.swift
//  BookJournal (macOS)
//
//  Created by Alex Seifert on 21.03.22.
//

import SwiftUI

struct MacEditBookStep6: View {
    @ObservedObject var bookModel: BookModel
    
    var body: some View {
        VStack {
            MacEditBookStepTitle("Genres")
            
            // Genres
            SearchListNamedElement<Genre>(
                title: "Genres",
                selectedData: $bookModel.genres,
                createTitle: "Create a Genre"
            )
        }
    }
}

struct MacEditBookStep6_Previews: PreviewProvider {
    @StateObject static var bookModel = BookModel()
    
    static var previews: some View {
        MacEditBookStep6(bookModel: bookModel)
            .frame(height: 500.0)
    }
}
