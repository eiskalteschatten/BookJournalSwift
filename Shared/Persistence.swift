//
//  Persistence.swift
//  Shared
//
//  Created by Alex Seifert on 23.01.22.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
            let newBook = Book(context: viewContext)
            newBook.createdAt = Date()
            newBook.updatedAt = Date()
            newBook.dateStarted = Date()
            newBook.dateFinished = Date()
            
            newBook.title = "Preview Book";
            newBook.pageCount = 325
            newBook.summary = "I'm a summary"
            newBook.commentary = "I'm a commentary"
            newBook.notes = "I'm some notes"
            newBook.rating = 3
            newBook.onWishlist = true
            
            let newAuthor = Author(context: viewContext)
            newAuthor.name = "Mark Twain"
            
            newBook.addToAuthors(newAuthor)
            
            let newEditor = Editor(context: viewContext)
            newEditor.name = "Ms. Editor"
            
            newBook.addToEditors(newEditor)
            
            let newCategory = Category(context: viewContext)
            newCategory.name = "Cranky Books"
            
            newBook.addToCategories(newCategory)
            
            let newTag = Tag(context: viewContext)
            newTag.name = "Hilarious"
            
            newBook.addToTags(newTag)
            
            let newGenre = Genre(context: viewContext)
            newGenre.name = "Horror"
            
            newBook.addToGenres(newGenre)
            
            let newTranslator = Translator(context: viewContext)
            newTranslator.name = "Mr. Trans"
            
            newBook.addToTranslators(newTranslator)
            
            newBook.languageReadIn = "de"
            newBook.originalLanguage = "fr"
            
            let newCountry = Country(context: viewContext)
            newCountry.name = "United Kingdom"
            
            newBook.countryOfOrigin = newCountry
        }
        do {
            try viewContext.save()
        } catch {
            // TODO: Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentCloudKitContainer

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "BookJournal")
        
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // TODO: Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                Typical reasons for an error here include:
                * The parent directory does not exist, cannot be created, or disallows writing.
                * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                * The device is out of space.
                * The store could not be migrated to the current model version.
                Check the error message to determine what the actual problem was.
                */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        #if DEBUG
        if container.persistentStoreCoordinator.persistentStores.first?.url != nil {
            print("sqlite path: ", container.persistentStoreCoordinator.persistentStores.first!.url!.absoluteString)
        }
        else {
            print("sqlite path: Cannot determine!")
        }
        #endif
    }
}
