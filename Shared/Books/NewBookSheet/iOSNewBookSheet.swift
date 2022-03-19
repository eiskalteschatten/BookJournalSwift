//
//  iOSNewBookSheet.swift
//  BookJournal (iOS)
//
//  Created by Alex Seifert on 25.02.22.
//

import SwiftUI
import CoreData
import WrappingHStack

struct iOSNewBookSheet: View {
    private enum Screen: Int {
        case addAuthors, addEditors, addTranslators, addPublisher, addCountryOfOrigin
    }
    
    @State private var screen: Screen?
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var title: String = ""
    @State private var pageCount: Int16?
    
    @State private var readingStatus: String = ""
    @State private var addDateStarted = false
    @State private var dateStarted: Date = Date()
    @State private var addDateFinished = false
    @State private var dateFinished: Date = Date()
    
    @State private var authors: [Author] = []
    @State private var editors: [Editor] = []
    
    @State private var bookFormat: String = ""
    @State private var publisher: Publisher?
    @State private var yearPublished: Int16?
    @State private var isbn: String = ""
    
    @State private var countryOfOrigin: Country?
    @State private var translators: [Translator] = []

    var body: some View {
        NavigationView {
            VStack {
                // Bookcover
                Menu {
                    Button {
                        // TODO: add function
                    } label: {
                        Label("Choose Image", systemImage: "photo")
                    }
                    Button {
                        // TODO: add function
                    } label: {
                        Label("Scan Image", systemImage: "viewfinder")
                    }
                } label: {
                    Image(systemName: "plus.square.dashed")
                        .font(.system(size: 200))
                }
                .padding(.vertical)
                
                // Title
                TextField(
                    "Enter title...",
                    text: $title
                )
                    .font(.system(size: 20, weight: .bold))
                    .multilineTextAlignment(.center)
                    .padding(.bottom)
                
                Form {
                    Section("Status") {
                        // Reading Status
                        Picker("Reading Status", selection: $readingStatus) {
                            ForEach(BookReadingStatus.allCases) { status in
                                Text(bookReadingStatusProperties[status]!)
                                    .tag(status.rawValue)
                            }
                        }
                        
                        // Date Started
                        if !addDateStarted {
                            Button("Add Date Started") {
                                addDateStarted.toggle()
                            }
                        }
                        else {
                            HStack {
                                DatePicker(selection: $dateStarted, displayedComponents: .date) {
                                    Text("Date Started")
                                }
                                
                                Button {
                                    addDateStarted.toggle()
                                } label: {
                                    Image(systemName: "xmark.circle")
                                        .foregroundColor(.red)
                                }
                                .padding(.leading, 5)
                            }
                        }
                        
                        // Date Finished
                        if !addDateFinished {
                            Button("Add Date Finished") {
                                addDateFinished.toggle()
                            }
                        }
                        else {
                            HStack {
                                DatePicker(selection: $dateFinished, displayedComponents: .date) {
                                    Text("Date Finished")
                                }
                                
                                Button {
                                    addDateFinished.toggle()
                                } label: {
                                    Image(systemName: "xmark.circle")
                                        .foregroundColor(.red)
                                }
                                .padding(.leading, 5)
                            }
                        }
                    }
                    
                    // People
                    Section("People") {
                        // Authors
                        NavigationLink(
                            destination: AuthorsSearchList(selectedItems: $authors),
                            tag: Screen.addAuthors,
                            selection: $screen,
                            label: { WrappingSmallChipsWithName<Author>(title: "Authors", data: authors, chipColor: .green) }
                        )
                        
                        // Editors
                        NavigationLink(
                            destination: EditorsSearchList(selectedItems: $editors),
                            tag: Screen.addEditors,
                            selection: $screen,
                            label: { WrappingSmallChipsWithName<Editor>(title: "Editors", data: editors) }
                        )
                    }
                    
                    // Page Count
                    Section("Page Count") {
                        TextField(
                            "Page Count",
                            value: $pageCount,
                            format: .number
                        )
                            .keyboardType(.numberPad)
                    }
                    
                    Section("Publication Details") {
                        // Book Format
                        Picker("Book Format", selection: $bookFormat) {
                            ForEach(BookFormat.allCases) { format in
                                Label(bookFormatProperties[format]![0], systemImage: bookFormatProperties[format]![1])
                                    .tag(format.rawValue)
                            }
                        }
                        
                        // Publisher
                        NavigationLink(
                            destination: PublishersSearchList(selectedItem: $publisher),
                            tag: Screen.addPublisher,
                            selection: $screen,
                            label: {
                                HStack {
                                    Text("Publisher")
                                    Spacer()
                                    if publisher != nil {
                                        if let name = publisher!.name {
                                            Text(name).opacity(0.5)
                                        }
                                    }
                                }
                            }
                        )
                        
                        // Year Published
                        TextField(
                            "Year Published",
                            value: $yearPublished,
                            format: .number
                        )
                            .keyboardType(.numberPad)
                        
                        // ISBN
                        TextField(
                            "ISBN",
                            text: $isbn
                        )
                            .keyboardType(.numberPad)
                    }
                    
                    // World
                    Section("World") {
                        // Country of Origin
                        NavigationLink(
                            destination: CountriesSearchList(selectedItem: $countryOfOrigin),
                            tag: Screen.addCountryOfOrigin,
                            selection: $screen,
                            label: {
                                HStack {
                                    Text("Country of Origin")
                                    Spacer()
                                    if countryOfOrigin != nil {
                                        if let name = countryOfOrigin!.name {
                                            Text(name).opacity(0.5)
                                        }
                                    }
                                }
                            }
                        )
                        
                        // Translators
                        NavigationLink(
                            destination: TranslatorsSearchList(selectedItems: $translators),
                            tag: Screen.addTranslators,
                            selection: $screen,
                            label: { WrappingSmallChipsWithName<Translator>(title: "Translators", data: translators) }
                        )
                    }
                }
            }
            .navigationBarTitle(Text("Add a New Book"), displayMode: .inline)
                .navigationBarItems(
                    leading: Button(action: {
                        dismiss()
                    }) {
                        Text("Cancel")
                    },
                    trailing: Button(action: {
                        addBook()
                        dismiss()
                    }) {
                        Text("Save").bold()
                    }
                )
        }
    }
    
    private func addBook() {
        withAnimation {
            let newBook = Book(context: viewContext)
            newBook.createdAt = Date()
            newBook.updatedAt = Date()
            
            newBook.title = title
            if let unwrapped = pageCount {
                newBook.pageCount = unwrapped
            }
                       
            newBook.readingStatus = readingStatus
            if addDateStarted {
                newBook.dateStarted = dateStarted
            }
            if addDateFinished {
                newBook.dateFinished = dateFinished
            }
            
            authors.forEach(newBook.addToAuthors)
            editors.forEach(newBook.addToEditors)
            translators.forEach(newBook.addToTranslators)

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

struct iOSNewBookSheet_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        Group {
            iOSNewBookSheet().preferredColorScheme(.dark).padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/).frame(height: /*@START_MENU_TOKEN@*/800.0/*@END_MENU_TOKEN@*/).environment(\.managedObjectContext, context)
        }
    }
}
