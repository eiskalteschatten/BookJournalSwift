//
//  MacNewBookStep2.swift
//  BookJournal (macOS)
//
//  Created by Alex Seifert on 21.03.22.
//

import SwiftUI

struct MacNewBookStep2: View {
    @ObservedObject var bookModel: BookModel
    
    var body: some View {
        VStack {
            MacNewBookStepTitle("Book Status")
            
            Form {
                Group {
                    // Reading Status
                    Picker("Reading Status:", selection: $bookModel.readingStatus) {
                        ForEach(BookReadingStatus.allCases) { status in
                            Text(bookReadingStatusProperties[status]!)
                                .tag(status.rawValue)
                        }
                    }
                }
                
                Group {
                    // Date Started
                    Toggle("Add Date Started", isOn: $bookModel.addDateStarted.animation())
                    
                    if bookModel.addDateStarted {
                        DatePicker(selection: $bookModel.dateStarted, displayedComponents: .date) {
                            Text("Date Started:")
                        }
                        .transition(.scale)
                    }
                    
                    // Date Finished
                    Toggle("Add Date Finished", isOn: $bookModel.addDateFinished.animation())
                
                    if bookModel.addDateFinished {
                        DatePicker(selection: $bookModel.dateFinished, displayedComponents: .date) {
                            Text("Date Finished:")
                        }
                        .transition(.scale)
                    }
                }
            }
        }
    }
}

struct MacNewBookStep2_Previews: PreviewProvider {
    @StateObject static var bookModel = BookModel()
    
    static var previews: some View {
        MacNewBookStep2(bookModel: bookModel)
            .frame(height: 500.0)
    }
}
