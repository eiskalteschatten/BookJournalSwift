//
//  MacContentView.swift
//  BookJournal (macOS)
//
//  Created by Alex Seifert on 04.04.22.
//

import SwiftUI

struct MacContentView: View {
    private enum Screen: Int {
        case allBooks, wishlist, currentlyReading, notReadYet, read, statistics
    }
    
    @State private var screen: Screen? = Screen(rawValue: UserDefaults.standard.integer(forKey: USER_LAST_SCREEN_KEY)) ?? .allBooks
    
    var body: some View {
        NavigationView {
            List {
                Section("Books") {
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
            .onChange(of: screen, perform: { _ in
                UserDefaults.standard.set(screen?.rawValue, forKey: USER_LAST_SCREEN_KEY)
            })

            EmptyView()
            MacBookViewWrapper()
        }
    }
}

struct MacContentView_Previews: PreviewProvider {
    static var previews: some View {
        MacContentView()
    }
}
