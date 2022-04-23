//
//  CreateGenre.swift
//  BookJournal (iOS)
//
//  Created by Alex Seifert on 19.03.22.
//

import SwiftUI

struct CreateGenre: View {
    #if os(iOS)
    @Binding var screen: GenresSearchListScreen?
    #else
    @Binding var showScreen: Bool
    #endif
    
    @State private var name: String = ""
    
    var body: some View {
        CreateElementView(title: "Create a Genre", close: close, save: save) {
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
    
    private func close() {
        #if os(iOS)
        screen = .home
        #else
        showScreen.toggle()
        #endif
    }
}

struct CreateGenre_Previews: PreviewProvider {
    #if os(iOS)
    @State static var screen: GenresSearchListScreen?
    #else
    @State static var showScreen: Bool = true
    #endif
    
    static var previews: some View {
        #if os(iOS)
        CreateGenre(screen: $screen)
        #else
        CreateGenre(showScreen: $showScreen)
        #endif
    }
}
