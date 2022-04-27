//
//  iOSContentView.swift
//  BookJournal (iOS)
//
//  Created by Alex Seifert on 04.04.22.
//

import SwiftUI

struct iOSContentView: View {
    @StateObject var bookContext = BookContext()
    
    var body: some View {
        TabView {
            iOSBooksView()
                .tabItem {
                    Label("Books", systemImage: "books.vertical")
                }
                .environmentObject(bookContext)

            iOSWishListView()
                .tabItem {
                    Label("Wishlist", systemImage: "list.star")
                }
                .environmentObject(bookContext)
        }
    }
}

struct iOSContentView_Previews: PreviewProvider {
    static var previews: some View {
        iOSContentView()
    }
}
