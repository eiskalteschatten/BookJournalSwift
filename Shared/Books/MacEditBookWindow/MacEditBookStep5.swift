//
//  MacEditBookStep5.swift
//  BookJournal (macOS)
//
//  Created by Alex Seifert on 21.03.22.
//

import SwiftUI

struct MacEditBookStep5: View {
    @ObservedObject var bookModel: BookModel
    
    var body: some View {
        VStack {
            MacEditBookStepTitle("Publication Details")
            
            // Publisher
            PublishersSearchList(title: "Publisher", selectedItem: $bookModel.publisher)
                
            Divider()
                .padding(.vertical)
            
            Form {
                // Book Format
                Picker("Book Format:", selection: $bookModel.bookFormat) {
                    ForEach(BookFormat.allCases) { format in
                        Label(bookFormatProperties[format]![0], systemImage: bookFormatProperties[format]![1])
                            .tag(format.rawValue)
                    }
                }
                
                // Year Published
                TextField(
                    "Year Published:",
                    value: $bookModel.yearPublished,
                    format: .number
                )

                // ISBN
                TextField(
                    "ISBN:",
                    text: $bookModel.isbn
                )
                
                // Page Count
                TextField(
                    "Page Count:",
                    value: $bookModel.pageCount,
                    format: .number
                )
            }
        }
    }
}

struct MacEditBookStep5_Previews: PreviewProvider {
    @StateObject static var bookModel = BookModel()
    
    static var previews: some View {
        MacEditBookStep5(bookModel: bookModel)
            .frame(height: 500.0)
    }
}