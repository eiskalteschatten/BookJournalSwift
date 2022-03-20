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
        case addAuthors, addEditors, addGenres, addCategories, addTags, addTranslators, addPublisher, addCountryOfOrigin
    }
    
    @Environment(\.dismiss) var dismiss

    @State private var screen: Screen?
    @StateObject private var newBookFormModel = NewBookFormModel()

    var body: some View {
        NavigationView {
            Form {
                Section {
                    VStack(alignment: .center) {
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
                                .font(.system(size: 150))
                        }
                        .padding(.vertical)
                        
                        // Title
                        TextField(
                            "Enter title...",
                            text: $newBookFormModel.title
                        )
                            .font(.system(size: 20, weight: .bold))
                            .multilineTextAlignment(.center)
                            .padding(.bottom)
                    }
                }
                
                Section("Status") {
                    // Reading Status
                    Picker("Reading Status", selection: $newBookFormModel.readingStatus) {
                        ForEach(BookReadingStatus.allCases) { status in
                            Text(bookReadingStatusProperties[status]!)
                                .tag(status.rawValue)
                        }
                    }
                    
                    // Date Started
                    if !newBookFormModel.addDateStarted {
                        Button("Add Date Started") {
                            newBookFormModel.addDateStarted.toggle()
                        }
                    }
                    else {
                        HStack {
                            DatePicker(selection: $newBookFormModel.dateStarted, displayedComponents: .date) {
                                Text("Date Started")
                            }
                            
                            Button {
                                newBookFormModel.addDateStarted.toggle()
                            } label: {
                                Image(systemName: "xmark.circle")
                                    .foregroundColor(.red)
                            }
                            .padding(.leading, 5)
                        }
                    }
                    
                    // Date Finished
                    if !newBookFormModel.addDateFinished {
                        Button("Add Date Finished") {
                            newBookFormModel.addDateFinished.toggle()
                        }
                    }
                    else {
                        HStack {
                            DatePicker(selection: $newBookFormModel.dateFinished, displayedComponents: .date) {
                                Text("Date Finished")
                            }
                            
                            Button {
                                newBookFormModel.addDateFinished.toggle()
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
                        destination: AuthorsSearchList(selectedItems: $newBookFormModel.authors),
                        tag: Screen.addAuthors,
                        selection: $screen,
                        label: { WrappingSmallChipsWithName<Author>(title: "Authors", data: newBookFormModel.authors, chipColor: AUTHOR_COLOR) }
                    )
                    
                    // Editors
                    NavigationLink(
                        destination: EditorsSearchList(selectedItems: $newBookFormModel.editors),
                        tag: Screen.addEditors,
                        selection: $screen,
                        label: { WrappingSmallChipsWithName<Editor>(title: "Editors", data: newBookFormModel.editors, chipColor: EDITOR_COLOR) }
                    )
                }
                
                // Book Information
                Section("Book Information") {
                    // Page Count
                    TextField(
                        "Page Count",
                        value: $newBookFormModel.pageCount,
                        format: .number
                    )
                        .keyboardType(.numberPad)
                    
                    // Genres
                    NavigationLink(
                        destination: GenresSearchList(selectedItems: $newBookFormModel.genres),
                        tag: Screen.addGenres,
                        selection: $screen,
                        label: { WrappingSmallChipsWithName<Genre>(title: "Genres", data: newBookFormModel.genres, chipColor: GENRE_COLOR) }
                    )
                    
                    // Categories
                    NavigationLink(
                        destination: CategoriesSearchList(selectedItems: $newBookFormModel.categories),
                        tag: Screen.addCategories,
                        selection: $screen,
                        label: { WrappingSmallChipsWithName<Category>(title: "Categories", data: newBookFormModel.categories, chipColor: CATEGORY_COLOR) }
                    )
                    
                    // Tags
                    NavigationLink(
                        destination: TagsSearchList(selectedItems: $newBookFormModel.tags),
                        tag: Screen.addTags,
                        selection: $screen,
                        label: { WrappingSmallChipsWithName<Tag>(title: "Tags", data: newBookFormModel.tags, chipColor: TAG_COLOR) }
                    )
                }
                
                Section("Publication Details") {
                    // Book Format
                    Picker("Book Format", selection: $newBookFormModel.bookFormat) {
                        ForEach(BookFormat.allCases) { format in
                            Label(bookFormatProperties[format]![0], systemImage: bookFormatProperties[format]![1])
                                .tag(format.rawValue)
                        }
                    }
                    
                    // Publisher
                    NavigationLink(
                        destination: PublishersSearchList(selectedItem: $newBookFormModel.publisher),
                        tag: Screen.addPublisher,
                        selection: $screen,
                        label: { PickerMimickerWithName<Publisher>(title: "Publisher", data: newBookFormModel.publisher) }
                    )
                    
                    // Year Published
                    TextField(
                        "Year Published",
                        value: $newBookFormModel.yearPublished,
                        format: .number
                    )
                        .keyboardType(.numberPad)
                    
                    // ISBN
                    TextField(
                        "ISBN",
                        text: $newBookFormModel.isbn
                    )
                        .keyboardType(.numberPad)
                }
                
                // World
                Section("World") {
                    // Country of Origin
                    NavigationLink(
                        destination: CountriesSearchList(selectedItem: $newBookFormModel.countryOfOrigin),
                        tag: Screen.addCountryOfOrigin,
                        selection: $screen,
                        label: { PickerMimickerWithName<Country>(title: "Country of Origin", data: newBookFormModel.countryOfOrigin) }
                    )
                    
                    // Translators
                    NavigationLink(
                        destination: TranslatorsSearchList(selectedItems: $newBookFormModel.translators),
                        tag: Screen.addTranslators,
                        selection: $screen,
                        label: { WrappingSmallChipsWithName<Translator>(title: "Translators", data: newBookFormModel.translators, chipColor: TRANSLATOR_COLOR) }
                    )
                    
                    LanguagePicker(title: "Original Language", selection: $newBookFormModel.originalLanguage)
                    LanguagePicker(title: "Language Read In", selection: $newBookFormModel.languageReadIn)
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
                        newBookFormModel.saveBook()
                        dismiss()
                    }) {
                        Text("Save").bold()
                    }
                )
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
