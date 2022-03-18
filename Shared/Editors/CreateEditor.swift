//
//  CreateEditor.swift
//  BookJournal
//
//  Created by Alex Seifert on 18.03.22.
//

import SwiftUI

struct CreateEditor: View {
    @Binding var screen: EditorsSearchListScreen?
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var name: String = ""
    
    var body: some View {
        Form {
            TextField(
                "Name",
                text: $name
            )
        }
        .navigationBarTitle(Text("Create an Editor"), displayMode: .inline)
            .navigationBarItems(
                trailing: Button(action: {
                    saveEditor()
                    screen = .home
                }) {
                    Text("Save").bold()
                }
            )
    }
    
    private func saveEditor() {
        let newEditor = Editor(context: viewContext)
        newEditor.createdAt = Date()
        newEditor.updatedAt = Date()
        newEditor.name = name
        
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

struct CreateEditor_Previews: PreviewProvider {
    @State static var screen: EditorsSearchListScreen?
    
    static var previews: some View {
        CreateEditor(screen: $screen)
    }
}
