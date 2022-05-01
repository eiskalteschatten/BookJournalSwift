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
                        predicate: NSPredicate(format: "readingStatus == %@", BookReadingStatus.currentlyReading.rawValue),
                        createOptions: BookModelCreateOptions(readingStatus: .currentlyReading)
                    ).navigationTitle("Currently Reading"),
                    tag: Screen.currentlyReading,
                    selection: $screen,
                    label: {
                        Label("Currently Reading", systemImage: "book")
                    }
                )
                NavigationLink(
                    destination: BookList(
                        predicate: NSPredicate(format: "readingStatus == %@", BookReadingStatus.notReadYet.rawValue),
                        createOptions: BookModelCreateOptions(readingStatus: .notReadYet)
                    ).navigationTitle("Not Read Yet"),
                    tag: Screen.notReadYet,
                    selection: $screen,
                    label: {
                        Label("Not Read Yet", systemImage: "book.closed")
                    }
                )
                NavigationLink(
                    destination: BookList(
                          predicate: NSPredicate(format: "readingStatus == %@", BookReadingStatus.read.rawValue),
                          createOptions: BookModelCreateOptions(readingStatus: .read)
                    ).navigationTitle("Books Read"),
                    tag: Screen.read,
                    selection: $screen,
                    label: {
                        Label("Books Read", systemImage: "checkmark.square")
                    }
                )
            }
            .navigationBarTitle("BookJournal")
            
            EmptyView()
            iOSBookViewWrapper()
        }
    }
}

// Show all three columns on iPad by default
extension UISplitViewController {
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.show(.primary)
    }
}

struct iOSLibraryView_Previews: PreviewProvider {
    static var previews: some View {
        iOSLibraryView()
    }
}
