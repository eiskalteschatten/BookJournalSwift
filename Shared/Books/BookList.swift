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
    
    @State private var selectedBook: Book?
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest private var books: FetchedResults<Book>
    
    init(predicate: NSPredicate? = nil) {
        self._books = FetchRequest<Book>(
            sortDescriptors: [NSSortDescriptor(keyPath: \Book.title, ascending: false)],
            predicate: predicate,
            animation: .default
        )
    }

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

    private func deleteBooks(offsets: IndexSet) {
        withAnimation {
            offsets.map { books[$0] }.forEach(viewContext.delete)

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
