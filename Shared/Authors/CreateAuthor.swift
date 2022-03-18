//
//  CreateAuthor.swift
//  BookJournal
//
//  Created by Alex Seifert on 18.03.22.
//

import SwiftUI

struct CreateAuthor: View {
    @Binding var screen: AuthorsSearchListScreen?
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var name: String = ""
    
    var body: some View {
        Form {
            TextField(
                "Name",
                text: $name
            )
        }
        .navigationBarTitle(Text("Create an Author"), displayMode: .inline)
            .navigationBarItems(
                trailing: Button(action: {
                    saveAuthor()
                    screen = .home
                }) {
                    Text("Save").bold()
                }
            )
    }
    
    private func saveAuthor() {
        let newAuthor = Author(context: viewContext)
        newAuthor.createdAt = Date()
        newAuthor.updatedAt = Date()
        newAuthor.name = name
        
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

struct CreateAuthor_Previews: PreviewProvider {
    @State static var screen: AuthorsSearchListScreen?
    
    static var previews: some View {
        CreateAuthor(screen: $screen)
    }
}
