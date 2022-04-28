//
//  iOSLibraryView.swift
//  BookJournal (iOS)
//
//  Created by Alex Seifert on 04.04.22.
//

import SwiftUI

struct iOSLibraryView: View {
    private enum Screen: Int {
        case allBooks, currentlyReading, notReadYet, read
    }
    
    @State private var screen: Screen?
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink(
                    destination: BookList().navigationTitle("All Books"),
                    tag: Screen.allBooks,
                    selection: $screen,
                    label: {
                        Label("All Books", systemImage: "books.vertical")
                    }
                )
                NavigationLink(
                    destination: BookList(
                        predicate: NSPredicate(format: "readingStatus == %@", BookReadingStatus.currentlyReading.rawValue)
                    ).navigationTitle("Currently Reading"),
                    tag: Screen.currentlyReading,
                    selection: $screen,
                    label: {
                        Label("Currently Reading", systemImage: "book")
                    }
                )
                NavigationLink(
                    destination: BookList(
                        predicate: NSPredicate(format: "readingStatus == %@", BookReadingStatus.notReadYet.rawValue)
                    ).navigationTitle("Not Read Yet"),
                    tag: Screen.notReadYet,
                    selection: $screen,
                    label: {
                        Label("Not Read Yet", systemImage: "book.closed")
                    }
                )
                NavigationLink(
                    destination: BookList(
                          predicate: NSPredicate(format: "readingStatus == %@", BookReadingStatus.read.rawValue)
                    ).navigationTitle("Books Read"),
                    tag: Screen.read,
                    selection: $screen,
                    label: {
                        Label("Books Read", systemImage: "checkmark.square")
                    }
                )
            }
            .navigationBarTitle("BookJournal")
            
            // TODO: something other than just text
            Text("Select a category")
            
            iOSBookViewWrapper()
        }
    }
}

struct iOSLibraryView_Previews: PreviewProvider {
    static var previews: some View {
        iOSLibraryView()
    }
}
