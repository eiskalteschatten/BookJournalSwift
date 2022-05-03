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
    @EnvironmentObject private var globalViewModel: GlobalViewModel
    
    private var predicate: NSPredicate?
    
    #if os(iOS)
    @State private var showNewBookSheet = false
    @State private var presentDeleteAlert = false
    @State private var indexSetToDelete: IndexSet?
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
                    destination: BookView(),
                    tag: book,
                    selection: $globalViewModel.selectedBook,
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
        .tint(.red)
        #if os(iOS)
        .sheet(isPresented: $showNewBookSheet) {
            iOSEditBookSheet(createOptions: createOptions)
        }
        .alert("Are you sure you want to delete this book?", isPresented: $presentDeleteAlert, actions: {
            Button("No", role: .cancel, action: { presentDeleteAlert = false })
            Button("Yes", role: .destructive, action: {
                if let offsets = indexSetToDelete {
                    deleteBooks(offsets: offsets)
                }
            })
        }, message: {
            Text("This is permanent.")
        })
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
        #if os(macOS)
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
        #else
        indexSetToDelete = offsets
        presentDeleteAlert.toggle()
        #endif
    }

    private func deleteBooks(offsets: IndexSet) {
        withAnimation {
            offsets.map { books[$0] }.forEach(viewContext.delete)
            globalViewModel.selectedBook = nil

            do {
                try viewContext.save()
            } catch {
                handleCoreDataError(error as NSError)
            }
        }
    }
}

struct BookList_Previews: PreviewProvider {
    static var previews: some View {
        BookList().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
