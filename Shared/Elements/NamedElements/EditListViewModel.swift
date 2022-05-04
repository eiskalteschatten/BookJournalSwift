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
    
    @Published var name: String = ""
    @Published var icon: String = DEFAULT_LIST_ICON
    
    init(list: ListOfBooks? = nil) {
        let persistenceController = PersistenceController.shared
        viewContext = persistenceController.container.viewContext
        self.list = list
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
}
