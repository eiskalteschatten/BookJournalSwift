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
        iOSNewBookSheet()
        #else
        VStack {
            Text("mac goes here")
            
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

struct NewBookSheet_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        Group {
            NewBookSheet().preferredColorScheme(.dark).padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/).frame(height: /*@START_MENU_TOKEN@*/800.0/*@END_MENU_TOKEN@*/).environment(\.managedObjectContext, context)
        }
    }
}
