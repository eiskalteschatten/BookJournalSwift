//
//  iOSNewBookSheet.swift
//  BookJournal (iOS)
//
//  Created by Alex Seifert on 25.02.22.
//

import SwiftUI
import CoreData

struct iOSNewBookSheet: View {
    private enum Screen: Int {
        case addAuthors, addEditors, addPublishers
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
    @State private var publishers: [Publisher] = []
    @State private var yearPublished: Int16?
    @State private var isbn: String = ""

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
                            destination: AuthorsSearchList(selectedItems: $authors).navigationTitle("Search Authors"),
                            tag: Screen.addAuthors,
                            selection: $screen,
                            label: {
                                HStack {
                                    if authors.count > 0 {
                                        ForEach(authors, id: \.self) { item in
                                            SmallChip(background: .green) {
                                                HStack(alignment: .center, spacing: 4) {
                                                    if let name = item.name {
                                                        Text(name)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    else {
                                        Text("Add Authors")
                                            .opacity(0.3)
                                    }
                                }
                            }
                        )
                        
                        // Editors
                        NavigationLink(
                            destination: EditorsSearchList(selectedItems: $editors).navigationTitle("Search Editors"),
                            tag: Screen.addEditors,
                            selection: $screen,
                            label: {
                                HStack {
                                    if editors.count > 0 {
                                        ForEach(editors, id: \.self) { item in
                                            SmallChip(background: .gray) {
                                                HStack(alignment: .center, spacing: 4) {
                                                    if let name = item.name {
                                                        Text(name)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    else {
                                        Text("Add Editors")
                                            .opacity(0.3)
                                    }
                                }
                            }
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
                            destination: PublishersSearchList(selectedItems: $publishers).navigationTitle("Search Publishers"),
                            tag: Screen.addPublishers,
                            selection: $screen,
                            label: {
                                HStack {
                                    if publishers.count > 0 {
                                        ForEach(publishers, id: \.self) { item in
                                            SmallChip(background: .gray) {
                                                HStack(alignment: .center, spacing: 4) {
                                                    if let name = item.name {
                                                        Text(name)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    else {
                                        Text("Add Publishers")
                                            .opacity(0.3)
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

            newBook.bookFormat = bookFormat
            publishers.forEach(newBook.addToPublishers)
            if let unwrapped = yearPublished {
                newBook.yearPublished = unwrapped
            }
            newBook.isbn = isbn
            
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
