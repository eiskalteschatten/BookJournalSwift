//
//  MacNewBookStep5.swift
//  BookJournal (macOS)
//
//  Created by Alex Seifert on 21.03.22.
//

import SwiftUI

struct MacNewBookStep5: View {
    @ObservedObject var bookModel: BookModel
    
    var body: some View {
        Form {
            // Book Format
            Picker("Book Format:", selection: $bookModel.bookFormat) {
                ForEach(BookFormat.allCases) { format in
                    Label(bookFormatProperties[format]![0], systemImage: bookFormatProperties[format]![1])
                        .tag(format.rawValue)
                }
            }

            // Publisher
            Text("Publisher")
    //        NavigationLink(
    //            destination: PublishersSearchList(selectedItem: $bookModel.publisher),
    //            tag: Screen.addPublisher,
    //            selection: $screen,
    //            label: { PickerMimickerWithName<Publisher>(title: "Publisher", data: bookModel.publisher) }
    //        )

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

struct MacNewBookStep5_Previews: PreviewProvider {
    @StateObject static var bookModel = BookModel()
    
    static var previews: some View {
        MacNewBookStep5(bookModel: bookModel)
    }
}
