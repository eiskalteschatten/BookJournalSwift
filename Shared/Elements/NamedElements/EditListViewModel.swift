//
//  EditListViewModel.swift
//  BookJournal
//
//  Created by Alex Seifert on 04.05.22.
//

import SwiftUI
import CoreData

class EditListViewModel: ObservableObject {
    private var viewContext: NSManagedObjectContext?
    private var list: ListOfBooks?
    
    var isEditing = false
    
    @Published var name: String = ""
    @Published var icon: String = DEFAULT_LIST_ICON
    
    init(list: ListOfBooks? = nil) {
        let persistenceController = PersistenceController.shared
        self.viewContext = persistenceController.container.viewContext
        self.list = list
        self.isEditing = list != nil
        initVariables()
    }
    
    func initVariables() {
        if let unwrappedList = list {
            name = unwrappedList.name ?? name
            icon = unwrappedList.icon ?? icon
        }
    }
    
    func save() {
        withAnimation {
            list = list != nil ? list : ListOfBooks(context: viewContext!)
            
            list!.createdAt = Date()
            list!.updatedAt = Date()
            list!.name = name
            list!.icon = icon
            
            do {
                try viewContext!.save()
            } catch {
                handleCoreDataError(error as NSError)
            }
        }
    }
    
    #if os(macOS)
    static func promptToDeleteList(_ list: ListOfBooks) {
        let alert = NSAlert()
        alert.messageText = "Are you sure you want to delete this list?"
        alert.informativeText = "Any books inside this list will not be deleted. This is permanent."
        alert.addButton(withTitle: "No")
        alert.addButton(withTitle: "Yes")
        alert.alertStyle = .warning
        
        let delete = alert.runModal() == NSApplication.ModalResponse.alertSecondButtonReturn
        
        if delete {
            deleteList(list)
        }
    }

    static func deleteList(_ list: ListOfBooks) {
        let persistenceController = PersistenceController.shared
        let viewContext = persistenceController.container.viewContext
        
        withAnimation {
            viewContext.delete(list)
            
            do {
                try viewContext.save()
            } catch {
                handleCoreDataError(error as NSError)
            }
        }
    }
    #endif
}
