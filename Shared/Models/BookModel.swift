//
//  BookModel.swift
//  BookJournal
//
//  Created by Alex Seifert on 20.03.22.
//

import SwiftUI
import CoreData

class BookModel: ObservableObject {
    @Published var title: String = ""
    
    @Published var readingStatus: String = ""
    @Published var addDateStarted = false
    @Published var dateStarted: Date = Date()
    @Published var addDateFinished = false
    @Published var dateFinished: Date = Date()
    
    @Published var authors: [Author] = []
    @Published var editors: [Editor] = []
    
    @Published var categories: [Category] = []
    @Published var tags: [Tag] = []
    @Published var genres: [Genre] = []
    
    @Published var bookFormat: String = ""
    @Published var publisher: Publisher?
    @Published var yearPublished: Int16?
    @Published var isbn: String = ""
    @Published var pageCount: Int16?
    
    @Published var countryOfOrigin: Country?
    @Published var translators: [Translator] = []
    @Published var originalLanguage: String = ""
    @Published var languageReadIn: String = ""
    
    private var viewContext: NSManagedObjectContext?
    
    init() {
        let persistenceController = PersistenceController.shared
        viewContext = persistenceController.container.viewContext
    }
    
    func saveBook() {
        withAnimation {
            let newBook = Book(context: viewContext!)
            newBook.createdAt = Date()
            newBook.updatedAt = Date()
            
            newBook.title = title
                       
            newBook.readingStatus = readingStatus
            if addDateStarted {
                newBook.dateStarted = dateStarted
            }
            if addDateFinished {
                newBook.dateFinished = dateFinished
            }
            
            authors.forEach(newBook.addToAuthors)
            editors.forEach(newBook.addToEditors)
            
            categories.forEach(newBook.addToCategories)
            tags.forEach(newBook.addToTags)
            genres.forEach(newBook.addToGenres)

            newBook.bookFormat = bookFormat
            if let unwrapped = publisher {
                newBook.publisher = unwrapped
            }
            if let unwrapped = yearPublished {
                newBook.yearPublished = unwrapped
            }
            newBook.isbn = isbn
            if let unwrapped = pageCount {
                newBook.pageCount = unwrapped
            }
            
            if let unwrapped = countryOfOrigin {
                newBook.countryOfOrigin = unwrapped
            }
            translators.forEach(newBook.addToTranslators)
            newBook.originalLanguage = originalLanguage
            newBook.languageReadIn = languageReadIn
            
            do {
                if viewContext!.hasChanges {
                    try viewContext!.save()
                }
            } catch {
                // TODO: Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
