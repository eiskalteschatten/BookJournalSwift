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
            MacChipsEditor<Author>(title: "Authors", data: bookModel.authors, chipColor: AUTHOR_COLOR, editAction: editAuthorsAction)
            
            Divider()
                .padding(.vertical)

            // Editors
            MacChipsEditor<Editor>(title: "Editors", data: bookModel.editors, chipColor: EDITOR_COLOR, editAction: editEditorsAction)
        }
    }
    
    private func editAuthorsAction() {
        
    }
    
    private func editEditorsAction() {
        
    }
}

struct MacNewBookStep3_Previews: PreviewProvider {
    @StateObject static var bookModel = BookModel()
    
    static var previews: some View {
        MacNewBookStep3(bookModel: bookModel)
            .frame(height: 500.0)
    }
}
