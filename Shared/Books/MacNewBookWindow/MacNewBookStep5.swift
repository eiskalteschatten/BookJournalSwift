//
//  MacNewBookStep5.swift
//  BookJournal (macOS)
//
//  Created by Alex Seifert on 21.03.22.
//

import SwiftUI

struct MacNewBookStep5: View {
    @ObservedObject var bookModel: BookModel
    
    @State private var showNewPublisherSheet = false
    
    var body: some View {
        VStack {
            MacNewBookStepTitle("Publication Details")
            
            // Publisher
            VStack(alignment: .leading) {
                HStack {
                    Text("Publisher")
                    Spacer()
                    Button(action: {
                        showNewPublisherSheet.toggle()
                    }, label: {
                        Text("New Publisher")
                    })
                }
                
                PublishersSearchList(selectedItem: $bookModel.publisher)
            }
            .padding(.vertical)
            .sheet(isPresented: $showNewPublisherSheet) {
                CreatePublisher(showScreen: $showNewPublisherSheet)
            }
            
            Form {
                // Book Format
                Picker("Book Format:", selection: $bookModel.bookFormat) {
                    ForEach(BookFormat.allCases) { format in
                        Label(bookFormatProperties[format]![0], systemImage: bookFormatProperties[format]![1])
                            .tag(format.rawValue)
                    }
                }
                
                // Page Count
                TextField(
                    "Page Count:",
                    value: $bookModel.pageCount,
                    format: .number
                )
                
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
            }
        }
    }
}

struct MacNewBookStep5_Previews: PreviewProvider {
    @StateObject static var bookModel = BookModel()
    
    static var previews: some View {
        MacNewBookStep5(bookModel: bookModel)
            .frame(height: 500.0)
    }
}
