//
//  CreateList.swift
//  BookJournal
//
//  Created by Alex Seifert on 04.05.22.
//

import SwiftUI

struct CreateList: View {
    #if os(iOS)
    @Binding var screen: SearchListNamedElementScreen?
    #else
    @Binding var showScreen: Bool
    #endif

    @State private var name: String = ""

    var body: some View {
        CreateElementView(title: "Create a List", close: close, save: save) {
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
        
        let newEntity = ListOfBooks(context: viewContext)
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

struct CreateList_Previews: PreviewProvider {
    static let viewContext = PersistenceController.preview.container.viewContext
    
    #if os(iOS)
    @State static var screen: SearchListNamedElementScreen?
    #else
    @State static var showScreen: Bool = true
    #endif
    
    static var previews: some View {
        #if os(iOS)
        CreateList(screen: $screen)
        #else
        CreateList(showScreen: $showScreen)
        #endif
    }
}
