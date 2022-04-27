//
//  BookList.swift
//  BookJournal
//
//  Created by Alex Seifert on 20.02.22.
//

import SwiftUI
import CoreData

struct BookList: View {
    var predicate: NSPredicate?
    
    @State private var id = UUID()
    
    @Environment(\.managedObjectContext) private var viewContext
    
    #if os(iOS)
    @State private var showNewBookSheet = false
    private typealias BookView = iOSiPadOSBookView
    #else
    private typealias BookView = MacBookView
    #endif
    
    @EnvironmentObject private var bookContext: BookContext
    
    var body: some View {
        List {
            if let books = bookContext.booksInBookList {
                ForEach(books) { book in
                    NavigationLink(
                        destination: BookView(),
                        tag: book,
                        selection: $bookContext.selectedBook,
                        label: {
                            BookListItem(book: book)
                        }
                    )
                }
                .onDelete(perform: deleteBooks)
                .id(id)
            }
        }
        .toolbar {
            #if os(iOS)
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
            #endif
            ToolbarItem {
                Button(action: {
                    #if os(iOS)
                    showNewBookSheet.toggle()
                    #else
                    let newBookWindow = MacNewBookWindowManager()
                    newBookWindow.openWindow()
                    #endif
                }) {
                    Label("Add Book", systemImage: "plus")
                }
            }
        }
        .onAppear {
            bookContext.fetchBooks(predicate: predicate)
            id = UUID()
        }
        #if os(iOS)
        .sheet(isPresented: $showNewBookSheet) {
            iOSEditBookSheet()
                .onDisappear {
                    bookContext.fetchBooks(predicate: predicate)
                    id = UUID()
                }
        }
        #endif
    }

    private func deleteBooks(offsets: IndexSet) {
        withAnimation {
            offsets.map { bookContext.booksInBookList![$0] }.forEach(viewContext.delete)
            bookContext.selectedBook = nil

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

struct BookList_Previews: PreviewProvider {
    static var previews: some View {
        BookList().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
