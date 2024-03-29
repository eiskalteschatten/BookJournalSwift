//
//  EditNamedElement.swift
//  BookJournal
//
//  Created by Alex Seifert on 28.04.22.
//

import SwiftUI
import CoreData

struct EditNamedElement<T: AbstractName>: View {
    var createTitle: String
    var editTitle: String
    
    @Binding var screen: SearchListNamedElementScreen?
    @Binding var showScreen: Bool
    
    @ObservedObject private var editNamedElementViewModel: EditNamedElementViewModel<T>
    
    // Navigvation View
    init(createTitle: String, editTitle: String, screen: Binding<SearchListNamedElementScreen?>, element: T? = nil) {
        self.createTitle = createTitle
        self.editTitle = editTitle
        self._screen = screen
        self._showScreen = Binding.constant(false)
        self.editNamedElementViewModel = EditNamedElementViewModel<T>(element: element)
    }
    
    // Screen View
    init(createTitle: String, editTitle: String, showScreen: Binding<Bool>, element: T? = nil) {
        self.createTitle = createTitle
        self.editTitle = editTitle
        self._screen = Binding.constant(nil)
        self._showScreen = showScreen
        self.editNamedElementViewModel = EditNamedElementViewModel<T>(element: element)
    }
    
    var body: some View {
        #if os(iOS)
        if screen == nil {
            NavigationView {
                InternalCreateElementView<T>(createTitle: createTitle, editTitle: editTitle, screen: $screen, showScreen: $showScreen, editNamedElementViewModel: editNamedElementViewModel)
            }
        }
        else {
            InternalCreateElementView<T>(createTitle: createTitle, editTitle: editTitle, screen: $screen, showScreen: $showScreen, editNamedElementViewModel: editNamedElementViewModel)
        }
        #else
        InternalCreateElementView<T>(createTitle: createTitle, editTitle: editTitle, screen: $screen, showScreen: $showScreen, editNamedElementViewModel: editNamedElementViewModel)
        #endif
    }
}

fileprivate struct InternalCreateElementView<T: AbstractName>: View {
    var createTitle: String
    var editTitle: String
    @Binding var screen: SearchListNamedElementScreen?
    @Binding var showScreen: Bool
    @ObservedObject var editNamedElementViewModel: EditNamedElementViewModel<T>
    
    var body: some View {
        CreateElementView(
            title: editNamedElementViewModel.isEditing ? editTitle : createTitle,
            close: close,
            save: editNamedElementViewModel.save
        ) {
            Form {
                TextField(
                    "Name",
                    text: $editNamedElementViewModel.name
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
    
    private func close() {
        if screen != nil {
            screen = .home
        }
        
        if showScreen {
            showScreen.toggle()
        }
    }
}

struct EditNamedElement_Previews: PreviewProvider {
    static let viewContext = PersistenceController.preview.container.viewContext
    
    @State static var screen: SearchListNamedElementScreen?
    @State static var showScreen: Bool = true
        
    static var previews: some View {
        EditNamedElement<Author>(createTitle: "Create an Author", editTitle: "Edit Author", screen: $screen)
        EditNamedElement<Author>(createTitle: "Create an Author", editTitle: "Edit Author", showScreen: $showScreen)
    }
}
