//
//  BookModel.swift
//  BookJournal
//
//  Created by Alex Seifert on 20.03.22.
//

import SwiftUI
import CoreData

struct BookModelCreateOptions {
    var readingStatus: BookReadingStatus?
    var onWishlist = false
}

final class BookModel: ObservableObject {
    private var viewContext: NSManagedObjectContext?
    private var book: Book?
    private var updatingBook = false
    
    @Published var bookcover: Data?
    
    @Published var title: String = ""
    @Published var rating: Int = 0
    @Published var onWishlist: Bool = false
    
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
    
    @Published var summary: String = ""
    @Published var commentary: String = ""
    @Published var notes: String = ""
    
    init(book: Book? = nil) {
        let persistenceController = PersistenceController.shared
        viewContext = persistenceController.container.viewContext
        self.book = book
        initVariables()
    }
    
    func save() {
        withAnimation {
            book = book != nil ? book : Book(context: viewContext!)
            
            if !updatingBook {
                book!.createdAt = Date()
            }
            book!.updatedAt = Date()

            if let unwrapped = bookcover {
                book!.bookcover = unwrapped
            }
            book!.title = title
            book!.rating = Int16(rating)
            book!.onWishlist = onWishlist

            book!.readingStatus = readingStatus
            book!.dateStarted = addDateStarted ? dateStarted : nil
            book!.dateFinished = addDateFinished ? dateFinished : nil

            authors.forEach(book!.addToAuthors)
            editors.forEach(book!.addToEditors)

            categories.forEach(book!.addToCategories)
            tags.forEach(book!.addToTags)
            genres.forEach(book!.addToGenres)

            book!.bookFormat = bookFormat
            if let unwrapped = publisher {
                book!.publisher = unwrapped
            }
            if let unwrapped = yearPublished {
                book!.yearPublished = unwrapped
            }
            book!.isbn = isbn
            if let unwrapped = pageCount {
                book!.pageCount = unwrapped
            }

            if let unwrapped = countryOfOrigin {
                book!.countryOfOrigin = unwrapped
            }
            translators.forEach(book!.addToTranslators)
            book!.originalLanguage = originalLanguage
            book!.languageReadIn = languageReadIn

            book!.summary = summary
            book!.commentary = commentary
            book!.notes = notes
            
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
    
    private func initVariables() {
        if let unwrappedBook = book {
            bookcover = unwrappedBook.bookcover
                
            title = unwrappedBook.title ?? title
            rating = unwrappedBook.rating != 0 ? Int(unwrappedBook.rating) : rating
            onWishlist = unwrappedBook.onWishlist

            readingStatus = unwrappedBook.readingStatus ?? readingStatus
            addDateStarted = unwrappedBook.dateStarted != nil
            dateStarted = unwrappedBook.dateStarted ?? dateStarted
            addDateFinished = unwrappedBook.dateFinished != nil
            dateFinished = unwrappedBook.dateFinished ?? dateStarted

            authors = unwrappedBook.authors?.allObjects as? [Author] ?? authors
            editors = unwrappedBook.editors?.allObjects as? [Editor] ?? editors

            categories = unwrappedBook.categories?.allObjects as? [Category] ?? categories
            tags = unwrappedBook.tags?.allObjects as? [Tag] ?? tags
            genres = unwrappedBook.genres?.allObjects as? [Genre] ?? genres

            bookFormat = unwrappedBook.bookFormat ?? bookFormat
            publisher = unwrappedBook.publisher ?? publisher
            yearPublished = unwrappedBook.yearPublished != 0 ? unwrappedBook.yearPublished : yearPublished
            isbn = unwrappedBook.isbn ?? isbn
            pageCount = unwrappedBook.pageCount != 0 ? unwrappedBook.pageCount : pageCount

            countryOfOrigin = unwrappedBook.countryOfOrigin ?? countryOfOrigin
            translators = unwrappedBook.translators?.allObjects as? [Translator] ?? translators
            originalLanguage = unwrappedBook.originalLanguage ?? originalLanguage
            languageReadIn = unwrappedBook.languageReadIn ?? languageReadIn

            summary = unwrappedBook.summary ?? summary
            commentary = unwrappedBook.commentary ?? commentary
            notes = unwrappedBook.notes ?? notes
        }
    }
}
