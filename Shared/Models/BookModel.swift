//
//  BookModel.swift
//  BookJournal
//
//  Created by Alex Seifert on 20.03.22.
//

import SwiftUI
import CoreData
import os

struct BookModelCreateOptions {
    var readingStatus: BookReadingStatus?
    var list: ListOfBooks?
}

final class BookModel: ObservableObject {
    private var viewContext: NSManagedObjectContext?
    private var book: Book?
    private var updatingBook = false
    private var createOptions: BookModelCreateOptions?
    
    @Published var bookcover: ImageStore?
    
    @Published var title: String = ""
    @Published var rating: Int = 0
    
    @Published var readingStatus: String = ""
    @Published var addDateStarted = false
    @Published var dateStarted: Date = Date()
    @Published var addDateFinished = false
    @Published var dateFinished: Date = Date()
    
    @Published var authors: [Author] = []
    @Published var editors: [Editor] = []
    
    @Published var lists: [ListOfBooks] = []
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
    
    init(
        book: Book? = nil,
        createOptions: BookModelCreateOptions? = nil
    ) {
        let persistenceController = PersistenceController.shared
        viewContext = persistenceController.container.viewContext
        self.book = book
        self.createOptions = createOptions
        initVariables()
    }
    
    private func initVariables() {
        // Editing a book
        if let unwrappedBook = book {
            bookcover = unwrappedBook.bookcover
                
            title = unwrappedBook.title ?? title
            rating = unwrappedBook.rating != 0 ? Int(unwrappedBook.rating) : rating

            readingStatus = unwrappedBook.readingStatus ?? readingStatus
            addDateStarted = unwrappedBook.dateStarted != nil
            dateStarted = unwrappedBook.dateStarted ?? dateStarted
            addDateFinished = unwrappedBook.dateFinished != nil
            dateFinished = unwrappedBook.dateFinished ?? dateStarted

            authors = unwrappedBook.authors?.allObjects as? [Author] ?? authors
            editors = unwrappedBook.editors?.allObjects as? [Editor] ?? editors

            lists = unwrappedBook.lists?.allObjects as? [ListOfBooks] ?? lists
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
        // Creating a book
        else if let unwrappedOptions = createOptions {
            readingStatus = unwrappedOptions.readingStatus?.rawValue ?? readingStatus
            
            if let unwrappedList = unwrappedOptions.list {
                lists.append(unwrappedList)
            }
        }
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
            else {
                let randomDefaultBookcover = getRandomDefaultBookcover()
                #if os(macOS)
                let image = NSImage(named: randomDefaultBookcover)!
                let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil)!
                let bitmapRep = NSBitmapImageRep(cgImage: cgImage)
                let data = bitmapRep.representation(using: NSBitmapImageRep.FileType.jpeg, properties: [:])!
                #else
                let image = UIImage(named: randomDefaultBookcover)!
                let data = image.jpegData(compressionQuality: 100)!
                #endif
                
                let imageStore = getBookcoverImageStore(data: Data(data))
                book!.bookcover = imageStore
            }
            
            book!.title = title
            book!.rating = Int16(rating)

            book!.readingStatus = readingStatus
            book!.dateStarted = addDateStarted ? dateStarted : nil
            book!.dateFinished = addDateFinished ? dateFinished : nil

            book!.authors = []
            authors.forEach(book!.addToAuthors)
            book!.editors = []
            editors.forEach(book!.addToEditors)

            book!.lists = []
            lists.forEach(book!.addToLists)
            book!.tags = []
            tags.forEach(book!.addToTags)
            book!.genres = []
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
            book!.translators = []
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
                handleCoreDataError(error as NSError)
            }
        }
    }
    
    private func getBookcoverImageStore(data: Data) -> ImageStore {
        if let unwrappedImage = book!.bookcover {
            unwrappedImage.updatedAt = Date()
            unwrappedImage.image = data
            return unwrappedImage
        }
        else {
            let image = ImageStore(context: viewContext!)
            image.createdAt = Date()
            image.updatedAt = Date()
            image.image = data
            return image
        }
    }
}
