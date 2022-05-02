//
//  Sidebar.swift
//  BookJournal
//
//  Created by Alex Seifert on 02.05.22.
//

import SwiftUI

struct Sidebar: View {
    private enum Screen: Int {
        case allBooks, wishlist, currentlyReading, notReadYet, read, statistics
    }
    
    private let defaults = UserDefaults.standard
    private let sidebarScreenKey = "Sidebar.screen"
    @State private var screen: Screen?
    
    var body: some View {
        List {
            Section("Library") {
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
            
            Section("Lists") {
                NavigationLink(
                    destination: BookList(
                        predicate: NSPredicate(format: "onWishlist == true"),
                        createOptions: BookModelCreateOptions(onWishlist: true)
                    ).navigationTitle("Wishlist"),
                    tag: Screen.wishlist,
                    selection: $screen,
                    label: {
                        Label("Wishlist", systemImage: "list.star")
                    }
                )
            }
            
//                Section("Statistics") {
//                    NavigationLink(
//                        destination: BookList().navigationTitle("Statistics"),
//                        tag: Screen.statistics,
//                        selection: $screen,
//                        label: {
//                            Label("Statistics", systemImage: "chart.bar")
//                        }
//                    )
//                }
        }
        .onChange(of: screen) { newScreen in
            defaults.set(newScreen?.rawValue, forKey: sidebarScreenKey)
        }
        .onAppear {
            if let restoredScreen = defaults.integer(forKey: sidebarScreenKey) as Int? {
                screen = Screen(rawValue: restoredScreen)
            }
        }
        #if os(iOS)
        .navigationBarTitle("BookJournal")
        #else
        .frame(minWidth: 200)
        #endif
    }
}

struct Sidebar_Previews: PreviewProvider {
    static var previews: some View {
        Sidebar()
    }
}
