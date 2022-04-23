//
//  CreateCountry.swift
//  BookJournal
//
//  Created by Alex Seifert on 18.03.22.
//

import SwiftUI

struct CreateCountry: View {
    #if os(iOS)
    @Binding var screen: CountriesSearchListScreen?
    #else
    @Binding var showScreen: Bool
    #endif
    
    @State private var name: String = ""
    
    var body: some View {
        CreateElementView(title: "Create a Country", close: close, save: save) {
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
        
        let newCountry = Country(context: viewContext)
        newCountry.createdAt = Date()
        newCountry.updatedAt = Date()
        newCountry.name = name
        
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

struct CreateCountry_Previews: PreviewProvider {
    #if os(iOS)
    @State static var screen: CountriesSearchListScreen?
    #else
    @State static var showScreen: Bool = true
    #endif
    
    static var previews: some View {
        #if os(iOS)
        CreateCountry(screen: $screen)
        #else
        CreateCountry(showScreen: $showScreen)
        #endif
    }
}
