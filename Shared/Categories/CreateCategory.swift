//
//  CreateCategory.swift
//  BookJournal
//
//  Created by Alex Seifert on 19.03.22.
//

import SwiftUI

struct CreateCategory: View {
    @Binding var screen: CategoriesSearchListScreen?
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var name: String = ""
    
    var body: some View {
        Form {
            TextField(
                "Name",
                text: $name
            )
        }
        #if os(iOS)
        .navigationBarTitle(Text("Create a Category"), displayMode: .inline)
            .navigationBarItems(
                trailing: Button(action: {
                    save()
                    screen = .home
                }) {
                    Text("Save").bold()
                }
            )
        #endif
    }
    
    private func save() {
        let newCategory = Category(context: viewContext)
        newCategory.createdAt = Date()
        newCategory.updatedAt = Date()
        newCategory.name = name
        
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

struct CreateCategory_Previews: PreviewProvider {
    @State static var screen: CategoriesSearchListScreen?
    
    static var previews: some View {
        CreateCategory(screen: $screen)
    }
}