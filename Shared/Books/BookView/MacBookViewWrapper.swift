//
//  MacBookViewWrapper.swift
//  BookJournal
//
//  Created by Alex Seifert on 27.04.22.
//

import SwiftUI

struct MacBookViewWrapper: View {
    var book: Book?
    
    var body: some View {
        Group {
            if let unwrappedBook = book {
                MacBookView(book: unwrappedBook)
            }
            else {
                NoBookSelected()
            }
        }
        .toolbar {
            ToolbarItem {
                Button(action: editBook) {
                    Label("Edit", systemImage: "pencil")
                }
                .disabled(book == nil)
            }
            ToolbarItem {
                Button(action: deleteBooks) {
                    Label("Delete", systemImage: "trash")
                }
                .disabled(book == nil)
            }
        }
    }
    
    private func editBook() {
        // TODO
    }
    
    private func deleteBooks() {
        // TODO
    }
}

struct MacBookViewWrapper_Previews: PreviewProvider {
    static var previews: some View {
        MacBookViewWrapper()
    }
}
