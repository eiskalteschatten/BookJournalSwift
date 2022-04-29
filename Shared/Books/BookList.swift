//
//  BookList.swift
//  BookJournal
//
//  Created by Alex Seifert on 20.02.22.
//

import SwiftUI
import CoreData

struct BookList: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    private var predicate: NSPredicate?
    
    @State private var selectedBook: Book?
    
    #if os(iOS)
    @State private var showNewBookSheet = false
    private typealias BookView = iOSBookViewWrapper
    #else
    private typealias BookView = MacBookViewWrapper
    #endif

    @FetchRequest private var books: FetchedResults<Book>
    
    private var createOptions: BookModelCreateOptions?
    
    init(
        predicate: NSPredicate? = nil,
        createOptions: BookModelCreateOptions? = nil
    ) {
        self._books = FetchRequest<Book>(
            sortDescriptors: [SortDescriptor(\Book.title, order: .forward)],
            predicate: predicate,
            animation: .default
        )
        self.createOptions = createOptions
    }

    var body: some View {
        List {
            ForEach(Array(books.enumerated()), id: \.element) { index, book in
                NavigationLink(
                    destination: BookView(book: $selectedBook),
                    tag: book,
                    selection: $selectedBook,
                    label: {
                        BookListItem(book: book)
                    }
                )
                .contextMenu {
                    Button("Add New Book", action: addNewBook)
                    Divider()
                    Button("Delete Book", role: .destructive, action: {
                        promptToDeleteBook(offsets: IndexSet([index]))
                    })
                }
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
                Button(action: addNewBook) {
                    Label("Add Book", systemImage: "plus")
                }
            }
        }
        #if os(iOS)
        .sheet(isPresented: $showNewBookSheet) {
            iOSEditBookSheet(createOptions: createOptions)
        }
        #else
        .frame(minWidth: 250)
        #endif
    }
    
    private func addNewBook() {
        #if os(iOS)
        showNewBookSheet.toggle()
        #else
        let newBookWindow = MacEditBookWindowManager()
        newBookWindow.openWindow(createOptions: createOptions)
        #endif
    }
    
    private func promptToDeleteBook(offsets: IndexSet) {
        let alert = NSAlert()
        alert.messageText = "Are you sure you want to delete this book?"
        alert.informativeText = "This is permanent."
        alert.addButton(withTitle: "No")
        alert.addButton(withTitle: "Yes")
        alert.alertStyle = .warning
        
        let delete = alert.runModal() == NSApplication.ModalResponse.alertSecondButtonReturn
        
        if delete {
            deleteBooks(offsets: offsets)
        }
    }

    private func deleteBooks(offsets: IndexSet) {
        withAnimation {
            offsets.map { books[$0] }.forEach(viewContext.delete)
            selectedBook = nil

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
