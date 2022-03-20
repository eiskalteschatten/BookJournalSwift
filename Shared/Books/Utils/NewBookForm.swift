//
//  NewBookForm.swift
//  BookJournal
//
//  Created by Alex Seifert on 20.03.22.
//

import SwiftUI
import CoreData

class NewBookForm: ObservableObject {
    @Environment(\.managedObjectContext) var viewContext

    var title: String = ""
    
    var readingStatus: String = ""
    var addDateStarted = false
    var dateStarted: Date = Date()
    var addDateFinished = false
    var dateFinished: Date = Date()
    
    var authors: [Author] = []
    var editors: [Editor] = []
    
    var pageCount: Int16?
    var genres: [Genre] = []
    var categories: [Category] = []
    var tags: [Tag] = []
    
    var bookFormat: String = ""
    var publisher: Publisher?
    var yearPublished: Int16?
    var isbn: String = ""
    
    var countryOfOrigin: Country?
    var translators: [Translator] = []
    var originalLanguage: String = ""
    var languageReadIn: String = ""
    
    func addBook() {
        withAnimation {
            let newBook = Book(context: viewContext)
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
            
            if let unwrapped = pageCount {
                newBook.pageCount = unwrapped
            }
            genres.forEach(newBook.addToGenres)
            categories.forEach(newBook.addToCategories)
            tags.forEach(newBook.addToTags)

            newBook.bookFormat = bookFormat
            if let unwrapped = publisher {
                newBook.publisher = unwrapped
            }
            if let unwrapped = yearPublished {
                newBook.yearPublished = unwrapped
            }
            newBook.isbn = isbn
            
            if let unwrapped = countryOfOrigin {
                newBook.countryOfOrigin = unwrapped
            }
            translators.forEach(newBook.addToTranslators)
            newBook.originalLanguage = originalLanguage
            newBook.languageReadIn = languageReadIn
            
            do {
                try viewContext.save()
            } catch {
                // TODO: Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
