//
//  iOSNewBookSheet.swift
//  BookJournal (iOS)
//
//  Created by Alex Seifert on 25.02.22.
//

import SwiftUI
import CoreData

struct iOSNewBookSheet: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var title: String = ""
    @State private var isbn: String = ""
    @State private var pageCount: Int16?

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Menu {
                        Button {
                            // TODO: add function
                        } label: {
                            Label("Choose Image", systemImage: "photo")
                        }
                        Button {
                            // TODO: add function
                        } label: {
                            Label("Scan Image", systemImage: "viewfinder")
                        }
                    } label: {
                        Image(systemName: "plus.square.dashed")
                            .font(.system(size: 200))
                    }
                    .padding(.bottom)
                    
                    TextField(
                        "Enter title...",
                        text: $title
                    )
                        .font(.system(size: 20, weight: .bold))
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    // ISBN
                    GroupBox(label:
                        Label("ISBN", systemImage: "barcode")
                    ) {
                        TextField(
                            "Enter ISBN...",
                            text: $isbn
                        )
                            .keyboardType(.numberPad)
                    }
                    .padding(.leading)
                    .padding(.trailing)
                    .padding(.bottom)
                    
                    // Page Count
                    GroupBox(label:
                        Label("Page Count", systemImage: "number")
                    ) {
                        TextField(
                            "Enter page count...",
                            value: $pageCount,
                            format: .number
                        )
                            .keyboardType(.numberPad)
                    }
                    .padding(.leading)
                    .padding(.trailing)
                    .padding(.bottom)
                }
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
    }
    
    private func addBook() {
        withAnimation {
            let newBook = Book(context: viewContext)
            newBook.createdAt = Date()
            newBook.updatedAt = Date()
            newBook.title = title;
            newBook.isbn = isbn;
            
            if pageCount != nil {
                newBook.pageCount = pageCount!;
            }

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

struct iOSNewBookSheet_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        Group {
            iOSNewBookSheet().preferredColorScheme(.dark).padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/).frame(height: /*@START_MENU_TOKEN@*/800.0/*@END_MENU_TOKEN@*/).environment(\.managedObjectContext, context)
        }
    }
}
