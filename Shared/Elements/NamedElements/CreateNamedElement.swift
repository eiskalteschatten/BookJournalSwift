//
//  CreateNamedElement.swift
//  BookJournal
//
//  Created by Alex Seifert on 28.04.22.
//

import SwiftUI
import CoreData

struct CreateNamedElement<T: AbstractName>: View {
    var title: String
    
    #if os(iOS)
    @Binding var screen: SearchListNamedElementScreen?
    #else
    @Binding var showScreen: Bool
    #endif
    
    @State private var name: String = ""
    
    var body: some View {
        CreateElementView(title: title, close: close, save: save) {
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
        
        let newEntity = T(context: viewContext)
        newEntity.createdAt = Date()
        newEntity.updatedAt = Date()
        newEntity.name = name
        
        do {
            try viewContext.save()
        } catch {
            handleCoreDataError(error as NSError)
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

struct CreateNamedElement_Previews: PreviewProvider {
    static let viewContext = PersistenceController.preview.container.viewContext
    
    #if os(iOS)
    @State static var screen: SearchListNamedElementScreen?
    #else
    @State static var showScreen: Bool = true
    #endif
        
    static var previews: some View {
        #if os(iOS)
        CreateNamedElement<Author>(title: "Create an Author", screen: $screen)
        #else
        CreateNamedElement<Author>(title: "Create an Author", showScreen: $showScreen)
        #endif
    }
}
