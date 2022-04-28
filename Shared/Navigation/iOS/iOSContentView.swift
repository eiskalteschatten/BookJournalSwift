//
//  iOSContentView.swift
//  BookJournal (iOS)
//
//  Created by Alex Seifert on 04.04.22.
//

import SwiftUI

struct iOSContentView: View {
    var body: some View {
        TabView {
            iOSLibraryView()
                .tabItem {
                    Label("Library", systemImage: "books.vertical")
                }

            iOSWishListView()
                .tabItem {
                    Label("Wishlist", systemImage: "list.star")
                }
        }
    }
}

struct iOSContentView_Previews: PreviewProvider {
    static var previews: some View {
        iOSContentView()
    }
}
