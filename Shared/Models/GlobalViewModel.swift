//
//  GlobalViewModel.swift
//  BookJournal
//
//  Created by Alex Seifert on 29.04.22.
//

import SwiftUI
import CoreData

final class GlobalViewModel: ObservableObject {
    private var viewContext: NSManagedObjectContext?
    
    @Published var selectedBook: Book?
    
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
