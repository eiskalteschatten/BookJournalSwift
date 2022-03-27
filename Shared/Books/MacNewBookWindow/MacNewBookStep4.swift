//
//  MacNewBookStep4.swift
//  BookJournal (macOS)
//
//  Created by Alex Seifert on 21.03.22.
//

import SwiftUI

struct MacNewBookStep4: View {
    @ObservedObject var bookModel: BookModel
    
    var body: some View {
        VStack {
            MacNewBookStepTitle("Categorization")

            // Categories
            CategoriesSearchList(selectedItems: $bookModel.categories)
            
            Divider()
                .padding(.vertical)
        
            // Tags
            TagsSearchList(selectedItems: $bookModel.tags)
        }
    }
}

struct MacNewBookStep4_Previews: PreviewProvider {
    @StateObject static var bookModel = BookModel()
    
    static var previews: some View {
        MacNewBookStep4(bookModel: bookModel)
            .frame(height: 500.0)
    }
}
