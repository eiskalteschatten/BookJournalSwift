//
//  CreatePublisher.swift
//  BookJournal
//
//  Created by Alex Seifert on 18.03.22.
//

import SwiftUI

struct CreatePublisher: View {
    #if os(iOS)
    @Binding var screen: PublishersSearchListScreen?
    #else
    @Binding var showScreen: Bool
    #endif
    
    @State private var name: String = ""
    
    var body: some View {
        CreateElementView(title: "Create a Publisher", close: close, save: save) {
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
        
        let newPublisher = Publisher(context: viewContext)
        newPublisher.createdAt = Date()
        newPublisher.updatedAt = Date()
        newPublisher.name = name
        
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

struct CreatePublisher_Previews: PreviewProvider {
    #if os(iOS)
    @State static var screen: PublishersSearchListScreen?
    #else
    @State static var showScreen: Bool = true
    #endif
    
    static var previews: some View {
        #if os(iOS)
        CreatePublisher(screen: $screen)
        #else
        CreatePublisher(showScreen: $showScreen)
        #endif
    }
}
