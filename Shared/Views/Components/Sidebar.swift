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
    @State private var screen: Screen?
    
    var body: some View {
        NavigationLink(
            destination: AllBooksView().navigationTitle("All Books"),
            tag: Screen.allBooks,
            selection: $screen,
            label: {
                Label("All Books", systemImage: "info.circle")
            }
        )
    }
}
