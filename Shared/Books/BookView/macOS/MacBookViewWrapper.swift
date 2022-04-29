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
                            promptToDeleteBook()
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
                Button(action: promptToDeleteBook) {
                    Label("Delete", systemImage: "trash")
                }
                .disabled(globalViewModel.selectedBook == nil)
            }
        }
    }
    
    private func promptToDeleteBook() {
        let alert = NSAlert()
        alert.messageText = "Are you sure you want to delete this book?"
        alert.informativeText = "This is permanent."
        alert.addButton(withTitle: "No")
        alert.addButton(withTitle: "Yes")
        alert.alertStyle = .warning
        
        let delete = alert.runModal() == NSApplication.ModalResponse.alertSecondButtonReturn
        
        if delete {
            deleteBook()
        }
    }
    
    private func deleteBook() {
        withAnimation {
            if let unwrappedBook = globalViewModel.selectedBook {
                globalViewModel.selectedBook = nil
                viewContext.delete(unwrappedBook)
                
                do {
                    try viewContext.save()
                } catch {
                    // TODO: Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nsError = error as NSError
                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }
            }
        }
    }
}

struct MacBookViewWrapper_Previews: PreviewProvider {
    static var previews: some View {
        MacBookViewWrapper()
    }
}
