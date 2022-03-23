//
//  MacNewBookStep3.swift
//  BookJournal (macOS)
//
//  Created by Alex Seifert on 21.03.22.
//

import SwiftUI

struct MacNewBookStep3: View {
    @ObservedObject var bookModel: BookModel
    
    @State private var showNewAuthorSheet = false
    @State private var showEditEditorsSheet = false
    
    var body: some View {
        VStack {
            MacNewBookStepTitle("People")
            
            // Authors
            VStack(alignment: .leading) {
                HStack {
                    Text("Authors")
                    Spacer()
                    Button(action: {
                        showNewAuthorSheet.toggle()
                    }, label: {
                        Text("New Author")
                    })
                }
                
                AuthorsSearchList(selectedItems: $bookModel.authors)
            }
            .padding(.bottom)
            .sheet(isPresented: $showNewAuthorSheet) {
                CreateAuthor(showScreen: $showNewAuthorSheet)
            }
            
//            MacChipsEditor<Author>(title: "Authors", data: bookModel.authors, chipColor: AUTHOR_COLOR, editAction: editAuthorsAction)
//                .padding(.bottom)
//                .sheet(isPresented: $showEditAuthorsSheet) {
//                    AuthorsSearchList(selectedItems: $bookModel.authors)
//                }

            // Editors
            VStack(alignment: .leading) {
                HStack {
                    Text("Editors")
                    Spacer()
                    Button(action: {}, label: {
                        Text("New Editor")
                    })
                }
                
                EditorsSearchList(selectedItems: $bookModel.editors)
            }
            
//            MacChipsEditor<Editor>(title: "Editors", data: bookModel.editors, chipColor: EDITOR_COLOR, editAction: editEditorsAction)
//                .sheet(isPresented: $showEditEditorsSheet) {
//                    EditorsSearchList(selectedItems: $bookModel.editors)
//                }
        }
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
