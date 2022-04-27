//
//  MacEditBookStep2.swift
//  BookJournal (macOS)
//
//  Created by Alex Seifert on 21.03.22.
//

import SwiftUI

struct MacEditBookStep2: View {
    @ObservedObject var bookModel: BookModel
    
    var body: some View {
        VStack {
            MacEditBookStepTitle("Book Status & Rating")
            
            BookRatingEditor(rating: $bookModel.rating)
            
            Divider()
                .padding(.vertical)
            
            Form {
                // Reading Status
                Picker("Reading Status:", selection: $bookModel.readingStatus) {
                    ForEach(BookReadingStatus.allCases) { status in
                        Text(bookReadingStatusProperties[status]!)
                            .tag(status.rawValue)
                    }
                }
                
                Divider()
                    .padding(.vertical)
                
                Group {
                    // Date Started
                    Toggle("Add Date Started", isOn: $bookModel.addDateStarted)
                    
                    DatePicker(selection: $bookModel.dateStarted, displayedComponents: .date) {
                        Text("Date Started:")
                    }
                    .disabled(!bookModel.addDateStarted)
                    .padding(.bottom)
                    
                    // Date Finished
                    Toggle("Add Date Finished", isOn: $bookModel.addDateFinished)
                
                    DatePicker(selection: $bookModel.dateFinished, displayedComponents: .date) {
                        Text("Date Finished:")
                    }
                    .disabled(!bookModel.addDateFinished)
                }
                
                Divider()
                    .padding(.vertical)
                
                // Wishlist
                Toggle("Add Book to Wishlist", isOn: $bookModel.onWishlist)
            }
        }
    }
}

struct MacEditBookStep2_Previews: PreviewProvider {
    @StateObject static var bookModel = BookModel()
    
    static var previews: some View {
        MacEditBookStep2(bookModel: bookModel)
            .frame(height: 500.0)
    }
}
