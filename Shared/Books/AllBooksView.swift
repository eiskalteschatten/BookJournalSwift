//
//  AllBooksView.swift
//  BookJournal
//
//  Created by Alex Seifert on 20.02.22.
//

import SwiftUI
import CoreData

struct AllBooksList: View {
    @State private var selectedBook: Book?
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Book.title, ascending: false)],
        animation: .default)
    private var books: FetchedResults<Book>

    var body: some View {
        List {
            ForEach(books) { book in
                NavigationLink(
                    destination: BookView(book: book),
                    tag: book,
                    selection: $selectedBook,
                    label: {
                        Text(book.title!)
                    }
                )
            }
            .onDelete(perform: deleteBooks)
        }
        .toolbar {
            #if os(iOS)
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
            #endif
            ToolbarItem {
                Button(action: addBook) {
                    Label("Add Book", systemImage: "plus")
                }
            }
        }
    }

    private func addBook() {
        withAnimation {
            let newBook = Book(context: viewContext)
            newBook.createdAt = Date()
            newBook.updatedAt = Date()
            newBook.title = "Untitled Book";

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteBooks(offsets: IndexSet) {
        withAnimation {
            offsets.map { books[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct AllBooksList_Previews: PreviewProvider {
    static var previews: some View {
        AllBooksList().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
