//
//  iOSiPadOSBookView.swift
//  BookJournal (iOS)
//
//  Created by Alex Seifert on 03.04.22.
//

import SwiftUI

struct iOSBookViewWrapper: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding var book: Book?
    @State private var showEditBookSheet = false
    
    init(book: Binding<Book?> = Binding.constant(nil)) {
        self._book = book
    }
    
    var body: some View {
        Group {
            if let unwrappedBook = book {
                if horizontalSizeClass == .regular && verticalSizeClass == .regular {
                    iPadOSBookView(book: unwrappedBook, showEditBookSheet: $showEditBookSheet)
                }
                else {
                    iOSBookView(book: unwrappedBook, showEditBookSheet: $showEditBookSheet)
                }
            }
            else {
                NoBookSelected()
            }
        }
        .toolbar {
            ToolbarItem {
                Menu {
                    Button(action: { showEditBookSheet.toggle() }) {
                        Label("Edit", systemImage: "pencil")
                    }
                    Divider()
                    Button(role: .destructive) { deleteBooks() } label: {
                        Label("Delete", systemImage: "trash")
                    }
                 } label: {
                     Image(systemName: "ellipsis.circle")
                 }
            }
        }
    }
    
    private func deleteBooks() {
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

struct iOSBookViewWrapper_Previews: PreviewProvider {
    static var previews: some View {
        iOSBookViewWrapper()
    }
}
