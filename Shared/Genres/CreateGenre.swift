//
//  CreateGenre.swift
//  BookJournal (iOS)
//
//  Created by Alex Seifert on 19.03.22.
//

import SwiftUI

struct CreateGenre: View {
    @Binding var screen: GenresSearchListScreen?
    
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
        .navigationBarTitle(Text("Create a Genre"), displayMode: .inline)
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
        let newGenre = Genre(context: viewContext)
        newGenre.createdAt = Date()
        newGenre.updatedAt = Date()
        newGenre.name = name
        
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

struct CreateGenre_Previews: PreviewProvider {
    @State static var screen: GenresSearchListScreen?
    
    static var previews: some View {
        CreateGenre(screen: $screen)
    }
}
