//
//  ContentView.swift
//  Shared
//
//  Created by Alex Seifert on 23.01.22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    enum Screen: Int {
        case allBooks, wishlist, currentlyReading, notReadYet, read, statistics
    }
    
    @State private var screen: Screen? = Screen(rawValue: UserDefaults.standard.integer(forKey: USER_LAST_SCREEN_KEY)) ?? .allBooks
    
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
                        predicate: NSPredicate(format: "onWishlist == true")
                    ).navigationTitle("Wishlist"),
                    tag: Screen.wishlist,
                    selection: $screen,
                    label: {
                        Label("Wishlist", systemImage: "list.star")
                    }
                )
                NavigationLink(
                    destination: BookList(
                        predicate: NSPredicate(format: "status == %@", BookStatus.currentlyReading.rawValue)
                    ).navigationTitle("Currently Reading"),
                    tag: Screen.currentlyReading,
                    selection: $screen,
                    label: {
                        Label("Currently Reading", systemImage: "book")
                    }
                )
                NavigationLink(
                    destination: BookList(
                        predicate: NSPredicate(format: "status == %@", BookStatus.notReadYet.rawValue)
                    ).navigationTitle("Not Read Yet"),
                    tag: Screen.notReadYet,
                    selection: $screen,
                    label: {
                        Label("Not Read Yet", systemImage: "book.closed")
                    }
                )
                NavigationLink(
                    destination: BookList(
                        predicate: NSPredicate(format: "status == %@", BookStatus.read.rawValue)
                    ).navigationTitle("Books Read"),
                    tag: Screen.read,
                    selection: $screen,
                    label: {
                        Label("Books Read", systemImage: "checkmark.square")
                    }
                )
//                NavigationLink(
//                    // TODO: create the statistics view
//                    destination: BookList().navigationTitle("Statistics"),
//                    tag: Screen.statistics,
//                    selection: $screen,
//                    label: {
//                        Label("Statistics", systemImage: "chart.bar")
//                    }
//                )
            }
            .onChange(of: screen, perform: { _ in
                UserDefaults.standard.set(screen?.rawValue, forKey: USER_LAST_SCREEN_KEY)
            })
            #if os(iOS)
            .navigationBarTitle("BookJournal")
            #endif
            
            // TODO: something other than just text
            Text("Select a category")
            
            BookView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}