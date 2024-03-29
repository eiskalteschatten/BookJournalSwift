//
//  MacEditBookStep3.swift
//  BookJournal (macOS)
//
//  Created by Alex Seifert on 21.03.22.
//

import SwiftUI

struct MacEditBookStep3: View {
    @ObservedObject var bookModel: BookModel
    
    var body: some View {
        VStack {
            MacEditBookStepTitle("People")
            
            // Authors
            SearchListNamedElement<Author>(
                title: "Authors",
                selectedData: $bookModel.authors,
                createTitle: "Create an Author",
                editTitle: "Edit Author"
            )
            
            Divider()
                .padding(.vertical)
            
            // Editors
            SearchListNamedElement<Editor>(
                title: "Editors",
                selectedData: $bookModel.editors,
                createTitle: "Create an Editor",
                editTitle: "Edit Editor"
            )
        }
    }
}

struct MacEditBookStep3_Previews: PreviewProvider {
    @StateObject static var bookModel = BookModel()
    
    static var previews: some View {
        MacEditBookStep3(bookModel: bookModel)
            .frame(height: 500.0)
    }
}
