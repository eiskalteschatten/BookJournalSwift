//
//  BookContext.swift
//  BookJournal
//
//  Created by Alex Seifert on 27.04.22.
//

import SwiftUI
import CoreData

final class BookContext: ObservableObject {
    @Published var booksInBookList: [Book]?
    @Published var selectedBook: Book?
    
    private var predicate: NSPredicate?
    private var viewContext: NSManagedObjectContext?
    
    init() {
        let persistenceController = PersistenceController.shared
        viewContext = persistenceController.container.viewContext
    }
    
    func fetchBooks(predicate: NSPredicate? = nil) {
        let fetchRequest: NSFetchRequest<Book> = Book.fetchRequest()
        fetchRequest.predicate = predicate
        self.predicate = predicate
        
        do {
            booksInBookList = try viewContext!.fetch(fetchRequest)
        } catch {
            // TODO: Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
