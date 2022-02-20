//
//  ContentView.swift
//  Shared
//
//  Created by Alex Seifert on 23.01.22.
//

import SwiftUI
import CoreData

enum Screen: Int {
    case allBooks
}

struct ContentView: View {
    @State private var screen: Screen? = Screen(rawValue: UserDefaults.standard.integer(forKey: USER_LAST_SCREEN_KEY)) ?? .allBooks
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink(
                    destination: AllBooksView().navigationTitle("All Books"),
                    tag: Screen.allBooks,
                    selection: $screen,
                    label: {
                        Label("All Books", systemImage: "books.vertical.fill")
                    }
                )
            }
            .onChange(of: screen, perform: { _ in
                UserDefaults.standard.set(screen?.rawValue, forKey: USER_LAST_SCREEN_KEY)
            })
            #if os(iOS)
            .navigationBarTitle("BookJournal")
            #endif
            
            AllBooksView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
