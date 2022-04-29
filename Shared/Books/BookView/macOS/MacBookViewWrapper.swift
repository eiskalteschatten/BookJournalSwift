//
//  MacBookViewWrapper.swift
//  BookJournal
//
//  Created by Alex Seifert on 27.04.22.
//

import SwiftUI

struct MacBookViewWrapper: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject private var globalViewModel: GlobalViewModel
    
    var body: some View {
        Group {
            if let unwrappedBook = globalViewModel.selectedBook {
                MacBookView()
                    .contextMenu {
                        Button("Add New Book", action: {
                            let newBookWindow = MacEditBookWindowManager()
                            newBookWindow.openWindow()
                        })
                        Button("Edit \"\(unwrappedBook.title!)\"", action: {
                            let newBookWindow = MacEditBookWindowManager(book: globalViewModel.selectedBook)
                            newBookWindow.openWindow()
                        })
                        Divider()
                        Button("Delete Book", role: .destructive, action: {
                            globalViewModel.promptToDeleteBook()
                        })
                    }
            }
            else {
                NoBookSelected()
            }
        }
        .toolbar {
            ToolbarItem {
                Button {
                    let newBookWindow = MacEditBookWindowManager(book: globalViewModel.selectedBook)
                    newBookWindow.openWindow()
                } label: {
                    Label("Edit", systemImage: "pencil")
                }
                .disabled(globalViewModel.selectedBook == nil)
            }
            ToolbarItem {
                Button(action: globalViewModel.promptToDeleteBook) {
                    Label("Delete", systemImage: "trash")
                }
                .disabled(globalViewModel.selectedBook == nil)
            }
        }
    }
}

struct MacBookViewWrapper_Previews: PreviewProvider {
    static var previews: some View {
        MacBookViewWrapper()
    }
}
