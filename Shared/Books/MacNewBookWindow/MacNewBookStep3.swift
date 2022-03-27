//
//  MacNewBookStep3.swift
//  BookJournal (macOS)
//
//  Created by Alex Seifert on 21.03.22.
//

import SwiftUI

struct MacNewBookStep3: View {
    @ObservedObject var bookModel: BookModel
    
    var body: some View {
        VStack {
            MacNewBookStepTitle("People")
            
            // Authors
            AuthorsSearchList(selectedItems: $bookModel.authors)
            
            Divider()
                .padding(.vertical)
            
            // Editors
            EditorsSearchList(selectedItems: $bookModel.editors)
        }
    }
}

struct MacNewBookStep3_Previews: PreviewProvider {
    @StateObject static var bookModel = BookModel()
    
    static var previews: some View {
        MacNewBookStep3(bookModel: bookModel)
            .frame(height: 500.0)
    }
}
