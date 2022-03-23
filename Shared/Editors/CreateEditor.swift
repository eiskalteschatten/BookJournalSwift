//
//  CreateEditor.swift
//  BookJournal
//
//  Created by Alex Seifert on 18.03.22.
//

import SwiftUI

struct CreateEditor: View {
    #if os(iOS)
    @Binding var screen: EditorsSearchListScreen?
    #else
    @Binding var showScreen: Bool
    #endif
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var name: String = ""
    
    var body: some View {
        CreateElementView(title: "Create an Editor", close: close, save: save) {
            Form {
                TextField(
                    "Name",
                    text: $name
                )
            }
        }
    }
    
    private func save() {
        let persistenceController = PersistenceController.shared
        let viewContext = persistenceController.container.viewContext
        
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
    
    private func close() {
        #if os(iOS)
        screen = .home
        #else
        showScreen.toggle()
        #endif
    }
}

struct CreateEditor_Previews: PreviewProvider {
    #if os(iOS)
    @State static var screen: EditorsSearchListScreen?
    #else
    @State static var showScreen: Bool = true
    #endif
    
    static var previews: some View {
        #if os(iOS)
        CreateEditor(screen: $screen)
        #else
        CreateEditor(showScreen: $showScreen)
        #endif
    }
}
