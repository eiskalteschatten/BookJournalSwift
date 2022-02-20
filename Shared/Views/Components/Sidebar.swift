//
//  Sidebar.swift
//  BookJournal
//
//  Created by Alex Seifert on 20.02.22.
//

import SwiftUI

enum Screen: Int {
    case allBooks
}

struct Sidebar: View {
    @State private var screen: Screen? = Screen(rawValue: UserDefaults.standard.integer(forKey: USER_LAST_SCREEN_KEY)) ?? .allBooks
    
    var body: some View {
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
    }
}
