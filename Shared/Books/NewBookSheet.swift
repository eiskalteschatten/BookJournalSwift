//
//  NewBookSheet.swift
//  BookJournal
//
//  Created by Alex Seifert on 24.02.22.
//

import SwiftUI
import CoreData

struct NewBookSheet: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        #if os(iOS)
        NavigationView {
            VStack {
                NewBookSheetContents()
            }
            .navigationBarTitle(Text("Add a New Book"), displayMode: .inline)
                .navigationBarItems(
                    leading: Button(action: {
                        dismiss()
                    }) {
                        Text("Cancel")
                    },
                    trailing: Button(action: {
                        addBook()
                        dismiss()
                    }) {
                        Text("Save").bold()
                    }
                )
        }
        #else
        VStack {
            NewBookSheetContents()
            
            HStack {
                Button("Cancel", action: {
                    dismiss()
                })
                Button("Save", action: {
                    addBook()
                    dismiss()
                })
            }
        }
        .padding(15)
        #endif
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
}

fileprivate struct NewBookSheetContents: View {
    var body: some View {
        Text("forms go here")
    }
}
