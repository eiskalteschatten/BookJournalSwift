//
//  EditNamedElementViewModel.swift
//  BookJournal
//
//  Created by Alex Seifert on 04.05.22.
//

import SwiftUI
import CoreData

final class EditNamedElementViewModel<T: AbstractName>: ObservableObject {
    private var viewContext: NSManagedObjectContext?
    private var element: T?
    
    var isEditing = false
    
    @Published var name: String = ""
    
    init(element: T? = nil) {
        let persistenceController = PersistenceController.shared
        viewContext = persistenceController.container.viewContext
        self.element = element
        self.isEditing = element != nil
        initVariables()
    }
    
    func initVariables() {
        if let unwrappedElement = element {
            name = unwrappedElement.name ?? name
        }
    }
    
    func save() {
        withAnimation {
            element = element != nil ? element : T(context: viewContext!)
            
            element!.createdAt = Date()
            element!.updatedAt = Date()
            element!.name = name
            
            do {
                try viewContext!.save()
            } catch {
                handleCoreDataError(error as NSError)
            }
        }
    }
    
    #if os(macOS)
    static func promptToDeleteElement(_ element: T) {
        let alert = NSAlert()
        alert.messageText = "Are you sure you want to delete this item?"
        alert.informativeText = "No books will be deleted."
        alert.addButton(withTitle: "No")
        alert.addButton(withTitle: "Yes")
        alert.alertStyle = .warning
        
        let delete = alert.runModal() == NSApplication.ModalResponse.alertSecondButtonReturn
        
        if delete {
            deleteElement(element)
        }
    }
    #endif

    static func deleteElement(_ element: T) {
        let persistenceController = PersistenceController.shared
        let viewContext = persistenceController.container.viewContext
        
        withAnimation {
            viewContext.delete(element)
            
            do {
                try viewContext.save()
            } catch {
                handleCoreDataError(error as NSError)
            }
        }
    }
}
