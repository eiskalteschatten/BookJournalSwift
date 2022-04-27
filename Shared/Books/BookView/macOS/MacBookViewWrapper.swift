//
//  MacBookViewWrapper.swift
//  BookJournal
//
//  Created by Alex Seifert on 27.04.22.
//

import SwiftUI

struct MacBookViewWrapper: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding var book: Book?
    
    init(book: Binding<Book?> = Binding.constant(nil)) {
        self._book = book
    }
    
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
                Button {
                    let newBookWindow = MacEditBookWindowManager(book: book)
                    newBookWindow.openWindow()
                } label: {
                    Label("Edit", systemImage: "pencil")
                }
                .disabled(book == nil)
            }
            ToolbarItem {
                Button(action: promptToDeleteBook) {
                    Label("Delete", systemImage: "trash")
                }
                .disabled(book == nil)
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
            if let unwrappedBook = book {
                book = nil
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
