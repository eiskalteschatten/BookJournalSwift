//
//  MacEditBookStep8.swift
//  BookJournal (macOS)
//
//  Created by Alex Seifert on 04.04.22.
//

import SwiftUI

struct MacEditBookStep8: View {
    @ObservedObject var bookModel: BookModel
    
    var body: some View {
        VStack {
            MacEditBookStepTitle("Summary, Commentary & Notes")
            
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

struct MacEditBookStep8_Previews: PreviewProvider {
    @StateObject static var bookModel = BookModel()
    
    static var previews: some View {
        MacEditBookStep8(bookModel: bookModel)
            .frame(height: 500.0)
    }
}
