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
    
    @Binding var screen: SearchListNamedElementScreen?
    @Binding var showScreen: Bool
    
    @State private var name: String = ""
    
    // Navigvation View
    init(title: String, screen: Binding<SearchListNamedElementScreen?>) {
        self.title = title
        self._screen = screen
        self._showScreen = Binding.constant(false)
    }
    
    // Screen View
    init(title: String, showScreen: Binding<Bool>) {
        self.title = title
        self._screen = Binding.constant(nil)
        self._showScreen = showScreen
    }
    
    var body: some View {
        #if os(iOS)
        if screen == nil {
            NavigationView {
                InternalCreateElementView<T>(title: title, screen: $screen, showScreen: $showScreen, name: $name)
            }
        }
        else {
            InternalCreateElementView<T>(title: title, screen: $screen, showScreen: $showScreen, name: $name)
        }
        #else
        InternalCreateElementView<T>(title: title, screen: $screen, showScreen: $showScreen, name: $name)
        #endif
    }
}

fileprivate struct InternalCreateElementView<T: AbstractName>: View {
    var title: String
    @Binding var screen: SearchListNamedElementScreen?
    @Binding var showScreen: Bool
    @Binding var name: String
    
    var body: some View {
        CreateElementView(title: title, close: close, save: save) {
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
        if screen != nil {
            screen = .home
        }
        
        if showScreen {
            showScreen.toggle()
        }
    }
}

struct CreateNamedElement_Previews: PreviewProvider {
    static let viewContext = PersistenceController.preview.container.viewContext
    
    @State static var screen: SearchListNamedElementScreen?
    @State static var showScreen: Bool = true
        
    static var previews: some View {
        CreateNamedElement<Author>(title: "Create an Author", screen: $screen)
        CreateNamedElement<Author>(title: "Create an Author", showScreen: $showScreen)
    }
}
