//
//  iOSWishListView.swift
//  BookJournal (iOS)
//
//  Created by Alex Seifert on 04.04.22.
//

import SwiftUI

struct iOSWishListView: View {
    var body: some View {
        NavigationView {
            BookList(predicate: NSPredicate(format: "onWishlist == true"))
                .navigationBarTitle("Wishlist")
            
            // TODO: something other than just text
            Text("Select a book")
        }
    }
}

struct iOSWishListView_Previews: PreviewProvider {
    static var previews: some View {
        iOSWishListView()
    }
}
