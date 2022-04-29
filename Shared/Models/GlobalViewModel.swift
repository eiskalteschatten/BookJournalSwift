//
//  GlobalViewModel.swift
//  BookJournal
//
//  Created by Alex Seifert on 29.04.22.
//

import SwiftUI

final class GlobalViewModel: ObservableObject {
    private var viewContext: NSManagedObjectContext?
    
    @Published var selectedBook: Book?
    
    init() {
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
                    // TODO: Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nsError = error as NSError
                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }
            }
        }
    }
    #endif
}
