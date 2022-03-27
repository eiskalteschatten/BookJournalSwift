//
//  MacNewBookStep3.swift
//  BookJournal (macOS)
//
//  Created by Alex Seifert on 21.03.22.
//

import SwiftUI

struct MacNewBookStep3: View {
    @ObservedObject var bookModel: BookModel
    
    @State private var showNewEditorSheet = false
    
    var body: some View {
        VStack {
            MacNewBookStepTitle("People")
            
            // Authors
            AuthorsSearchList(selectedItems: $bookModel.authors)
            
            Divider()
                .padding(.vertical)
            
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
