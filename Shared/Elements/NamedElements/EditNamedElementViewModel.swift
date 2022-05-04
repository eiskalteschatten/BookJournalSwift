//
//  EditNamedElementViewModel.swift
//  BookJournal
//
//  Created by Alex Seifert on 04.05.22.
//

import SwiftUI
import CoreData

class EditNamedElementViewModel<T: AbstractName>: ObservableObject {
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
}
