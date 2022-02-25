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
    @State private var title: String = ""
    
    var body: some View {
        Menu {
            Button {
                
            } label: {
                Label("Choose Image", systemImage: "photo")
            }
            Button {
                
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

