//
//  MacNewBookStep3.swift
//  BookJournal (macOS)
//
//  Created by Alex Seifert on 21.03.22.
//

import SwiftUI

struct MacNewBookStep3: View {
    @ObservedObject var bookModel: BookModel
    
    @State private var showEditAuthorsSheet = false
    @State private var showEditEditorsSheet = false
    
    var body: some View {
        VStack {
            MacNewBookStepTitle("People")
            
            // Authors
            MacChipsEditor<Author>(title: "Authors", data: bookModel.authors, chipColor: AUTHOR_COLOR, editAction: editAuthorsAction)
                .padding(.bottom)
                .sheet(isPresented: $showEditAuthorsSheet) {
                    AuthorsSearchList(selectedItems: $bookModel.authors)
                }

            // Editors
            MacChipsEditor<Editor>(title: "Editors", data: bookModel.editors, chipColor: EDITOR_COLOR, editAction: editEditorsAction)
                .sheet(isPresented: $showEditEditorsSheet) {
                    EditorsSearchList(selectedItems: $bookModel.editors)
                }
        }
    }
    
    private func editAuthorsAction() {
        showEditAuthorsSheet.toggle()
    }
    
    private func editEditorsAction() {
        showEditEditorsSheet.toggle()
    }
}

struct MacNewBookStep3_Previews: PreviewProvider {
    @StateObject static var bookModel = BookModel()
    
    static var previews: some View {
        MacNewBookStep3(bookModel: bookModel)
            .frame(height: 500.0)
    }
}
