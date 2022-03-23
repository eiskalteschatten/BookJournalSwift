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
    @State private var showNewEditorSheet = false
    
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
            
            // Editors
            VStack(alignment: .leading) {
                HStack {
                    Text("Editors")
                    Spacer()
                    Button(action: {
                        showNewEditorSheet.toggle()
                    }, label: {
                        Text("New Editor")
                    })
                }
                
                EditorsSearchList(selectedItems: $bookModel.editors)
            }
            .sheet(isPresented: $showNewEditorSheet) {
                CreateEditor(showScreen: $showNewEditorSheet)
            }
            
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
