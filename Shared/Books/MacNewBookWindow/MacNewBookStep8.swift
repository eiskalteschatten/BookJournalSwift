//
//  MacNewBookStep8.swift
//  BookJournal (macOS)
//
//  Created by Alex Seifert on 04.04.22.
//

import SwiftUI

struct MacNewBookStep8: View {
    @ObservedObject var bookModel: BookModel
    
    var body: some View {
        VStack {
            MacNewBookStepTitle("Summary, Commentary & Notes")
            
            Form {
                // Summary
                Text("Summary:")
                TextEditor(text: $bookModel.summary)
                
                // Commentary
                Text("Commentary:")
                TextEditor(text: $bookModel.commentary)
                
                // Notes
                Text("Notes:")
                TextEditor(text: $bookModel.notes)
            }
        }
    }
}

struct MacNewBookStep8_Previews: PreviewProvider {
    @StateObject static var bookModel = BookModel()
    
    static var previews: some View {
        MacNewBookStep8(bookModel: bookModel)
            .frame(height: 500.0)
    }
}
