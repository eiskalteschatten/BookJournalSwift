//
//  GlobalViewModel.swift
//  BookJournal
//
//  Created by Alex Seifert on 29.04.22.
//

import SwiftUI
import CoreData

final class GlobalViewModel: ObservableObject {
    private let defaults = UserDefaults.standard
    private var viewContext: NSManagedObjectContext?
    
    @Published var selectedBook: Book? {
        didSet {
            // Use user defaults instead of @SceneStorage here so that a URL object can be stored
            defaults.set(selectedBook?.objectID.uriRepresentation(), forKey: "selectedBookId")
        }
    }
    
    #if os(iOS)
    @Published var globalError: String?
    @Published var globalErrorSubtext: String?
    @Published var showGlobalErrorAlert: Bool = false {
        didSet {
            if !showGlobalErrorAlert {
                globalError = nil
                globalErrorSubtext = nil
            }
        }
    }
    #endif
    
    static let shared: GlobalViewModel = GlobalViewModel()
    
    private init() {
        let persistenceController = PersistenceController.shared
        viewContext = persistenceController.container.viewContext
        
        if let url = defaults.url(forKey: "selectedBookId"),
           let objectID = viewContext!.persistentStoreCoordinator!.managedObjectID(forURIRepresentation: url),
           let book = try? viewContext!.existingObject(with: objectID) as? Book {
                selectedBook = book
        }
    }
    
    #if os(macOS)
    func promptToDeleteBook() {
        let alert = NSAlert()
        alert.messageText = "Are you sure you want to delete this book?"
        alert.informativeText = "This is permanent."
        alert.addButton(withTitle: "No")
        alert.addButton(withTitle: "Yes")
        alert.alertStyle = .warning
        
        let delete = alert.runModal() == NSApplication.ModalResponse.alertSecondButtonReturn
        
        if delete {
            deleteBook()
        }
    }
    
    func deleteBook() {
        withAnimation {
            if let unwrappedBook = selectedBook {
                selectedBook = nil
                viewContext!.delete(unwrappedBook)
                
                do {
                    try viewContext!.save()
                } catch {
                    handleCoreDataError(error as NSError)
                }
            }
        }
    }
    #endif
}
