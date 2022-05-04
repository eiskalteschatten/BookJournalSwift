//
//  CreateList.swift
//  BookJournal
//
//  Created by Alex Seifert on 04.05.22.
//

import SwiftUI

struct CreateList: View {
    @Binding var screen: SearchListNamedElementScreen?
    @Binding var showScreen: Bool

    @State private var name: String = ""
    
    init(screen: Binding<SearchListNamedElementScreen?>) {
        self._screen = screen
        self._showScreen = Binding.constant(false)
    }
    
    init(showScreen: Binding<Bool>) {
        self._screen = Binding.constant(nil)
        self._showScreen = showScreen
    }

    var body: some View {
        #if os(iOS)
        if screen == nil {
            NavigationView {
                InternalCreateElementView(screen: $screen, showScreen: $showScreen, name: $name)
            }
        }
        else {
            InternalCreateElementView(screen: $screen, showScreen: $showScreen, name: $name)
        }
        #else
        InternalCreateElementView(screen: $screen, showScreen: $showScreen, name: $name)
        #endif
    }
}

fileprivate struct InternalCreateElementView: View {
    @Binding var screen: SearchListNamedElementScreen?
    @Binding var showScreen: Bool
    @Binding var name: String
    
    var body: some View {
        CreateElementView(title: "Create a List", close: close, save: save) {
            Form {
                TextField(
                    "Name",
                    text: $name
                )
            }
        }
        #if os(iOS)
        .if(screen == nil) { view in
            view.navigationBarItems(
                leading: Button(action: {
                    close()
                }) {
                    Text("Cancel")
                }
            )
        }
        #endif
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
        screen = .home
        showScreen.toggle()
    }
}

struct CreateList_Previews: PreviewProvider {
    static let viewContext = PersistenceController.preview.container.viewContext
    
    @State static var screen: SearchListNamedElementScreen?
    @State static var showScreen = true
    
    static var previews: some View {
        CreateList(screen: $screen)
        CreateList(showScreen: $showScreen)
    }
}
