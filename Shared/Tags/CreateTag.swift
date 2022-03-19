//
//  CreateTag.swift
//  BookJournal (iOS)
//
//  Created by Alex Seifert on 19.03.22.
//

import SwiftUI

struct CreateTag: View {
    @Binding var screen: TagsSearchListScreen?
    
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
        .navigationBarTitle(Text("Create a Tag"), displayMode: .inline)
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
        let newTag = Tag(context: viewContext)
        newTag.createdAt = Date()
        newTag.updatedAt = Date()
        newTag.name = name
        
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

struct CreateTag_Previews: PreviewProvider {
    @State static var screen: TagsSearchListScreen?
    
    static var previews: some View {
        CreateTag(screen: $screen)
    }
}
