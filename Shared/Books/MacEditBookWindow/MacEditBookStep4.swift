//
//  MacEditBookStep4.swift
//  BookJournal (macOS)
//
//  Created by Alex Seifert on 21.03.22.
//

import SwiftUI

struct MacEditBookStep4: View {
    @ObservedObject var bookModel: BookModel
    
    var body: some View {
        VStack {
            MacEditBookStepTitle("Categorization")

            // Categories
            SearchListNamedElement<ListOfBooks>(
                title: "Lists",
                selectedData: $bookModel.lists,
                createTitle: "Create a List"
            )
            
            Divider()
                .padding(.vertical)
        
            // Tags
            SearchListNamedElement<Tag>(
                title: "Tags",
                selectedData: $bookModel.tags,
                createTitle: "Create a Tag"
            )
        }
    }
}

struct MacEditBookStep4_Previews: PreviewProvider {
    @StateObject static var bookModel = BookModel()
    
    static var previews: some View {
        MacEditBookStep4(bookModel: bookModel)
            .frame(height: 500.0)
    }
}
