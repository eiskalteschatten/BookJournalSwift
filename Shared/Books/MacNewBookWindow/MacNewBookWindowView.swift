//
//  MacNewBookWindowView.swift
//  BookJournal (iOS)
//
//  Created by Alex Seifert on 25.02.22.
//

import SwiftUI

struct MacNewBookWindowView: View {
    private enum Screen: Int {
        case addAuthors, addEditors, addGenres, addCategories, addTags, addTranslators, addPublisher, addCountryOfOrigin
    }
       
    @State private var screen: Screen?
    @StateObject private var bookModel = BookModel()
    
    var body: some View {
        let spacerHeight = 10.0
        
        VStack(alignment: .trailing) {
            HStack {
                VStack {
                    // Bookcover
                    Image(systemName: "plus.square.dashed")
                        .font(.system(size: 150))
                        .foregroundColor(.accentColor)
                    
                    Button {
                        // TODO: add function
                    } label: {
                        Text("Choose Image")
                    }
                    
                    Button {
                        // TODO: add function
                    } label: {
                        Text("Scan Image")
                    }
                }
                .padding(.trailing, 25)
                
                Form {
                    Group {
                        // Title
                        TextField(
                            "Title:",
                            text: $bookModel.title
                        )
                        
                        // Reading Status
                        Picker("Reading Status:", selection: $bookModel.readingStatus) {
                            ForEach(BookReadingStatus.allCases) { status in
                                Text(bookReadingStatusProperties[status]!)
                                    .tag(status.rawValue)
                            }
                        }
                        
                        Divider()
                            .padding(.vertical, spacerHeight)
                    }
                    
                    Group {
                        // Date Started
                        Toggle("Add Date Started", isOn: $bookModel.addDateStarted)
                        
                        DatePicker(selection: $bookModel.dateStarted, displayedComponents: .date) {
                            Text("Date Started:")
                        }
                        .disabled(bookModel.addDateStarted == false)
                        
                        // Date Finished
                        Toggle("Add Date Finished", isOn: $bookModel.addDateFinished)
                    
                        DatePicker(selection: $bookModel.dateFinished, displayedComponents: .date) {
                            Text("Date Finished:")
                        }
                        .disabled(bookModel.addDateFinished == false)
                        
                        Divider()
                            .padding(.vertical, spacerHeight)
                    }
                    
                    // People
                    Group {
                        // Authors
                        NavigationLink(
                            destination: AuthorsSearchList(selectedItems: $bookModel.authors),
                            tag: Screen.addAuthors,
                            selection: $screen,
                            label: { WrappingSmallChipsWithName<Author>(title: "Authors", data: bookModel.authors, chipColor: AUTHOR_COLOR) }
                        )
        
                        // Editors
                        NavigationLink(
                            destination: EditorsSearchList(selectedItems: $bookModel.editors),
                            tag: Screen.addEditors,
                            selection: $screen,
                            label: { WrappingSmallChipsWithName<Editor>(title: "Editors", data: bookModel.editors, chipColor: EDITOR_COLOR) }
                        )
                        
                        Divider()
                            .padding(.vertical, spacerHeight)
                    }
                    
                    // Book Information
                    Group {
                        // Page Count
                        TextField(
                            "Page Count:",
                            value: $bookModel.pageCount,
                            format: .number
                        )
                            
                        // Genres
                        NavigationLink(
                            destination: GenresSearchList(selectedItems: $bookModel.genres),
                            tag: Screen.addGenres,
                            selection: $screen,
                            label: { WrappingSmallChipsWithName<Genre>(title: "Genres", data: bookModel.genres, chipColor: GENRE_COLOR) }
                        )
        
                        // Categories
                        NavigationLink(
                            destination: CategoriesSearchList(selectedItems: $bookModel.categories),
                            tag: Screen.addCategories,
                            selection: $screen,
                            label: { WrappingSmallChipsWithName<Category>(title: "Categories", data: bookModel.categories, chipColor: CATEGORY_COLOR) }
                        )
        
                        // Tags
                        NavigationLink(
                            destination: TagsSearchList(selectedItems: $bookModel.tags),
                            tag: Screen.addTags,
                            selection: $screen,
                            label: { WrappingSmallChipsWithName<Tag>(title: "Tags", data: bookModel.tags, chipColor: TAG_COLOR) }
                        )
                        
                        Divider()
                            .padding(.vertical, spacerHeight)
                    }
                        
                    Group {
                        // Book Format
                        Picker("Book Format:", selection: $bookModel.bookFormat) {
                            ForEach(BookFormat.allCases) { format in
                                Label(bookFormatProperties[format]![0], systemImage: bookFormatProperties[format]![1])
                                    .tag(format.rawValue)
                            }
                        }
                            
                        // Publisher
                        NavigationLink(
                            destination: PublishersSearchList(selectedItem: $bookModel.publisher),
                            tag: Screen.addPublisher,
                            selection: $screen,
                            label: { PickerMimickerWithName<Publisher>(title: "Publisher", data: bookModel.publisher) }
                        )
                            
                        // Year Published
                        TextField(
                            "Year Published:",
                            value: $bookModel.yearPublished,
                            format: .number
                        )
                        
                        // ISBN
                        TextField(
                            "ISBN:",
                            text: $bookModel.isbn
                        )
                        
                        Divider()
                            .padding(.vertical, spacerHeight)
                    }
                    
                    // World
                    Group {
                        // Country of Origin
                        NavigationLink(
                            destination: CountriesSearchList(selectedItem: $bookModel.countryOfOrigin),
                            tag: Screen.addCountryOfOrigin,
                            selection: $screen,
                            label: { PickerMimickerWithName<Country>(title: "Country of Origin", data: bookModel.countryOfOrigin) }
                        )
        
                        // Translators
                        NavigationLink(
                            destination: TranslatorsSearchList(selectedItems: $bookModel.translators),
                            tag: Screen.addTranslators,
                            selection: $screen,
                            label: { WrappingSmallChipsWithName<Translator>(title: "Translators", data: bookModel.translators, chipColor: TRANSLATOR_COLOR) }
                        )
        
                        LanguagePicker(title: "Original Language", selection: $bookModel.originalLanguage)
                        LanguagePicker(title: "Language Read In", selection: $bookModel.languageReadIn)
                    }
                }
            }
            .padding(.bottom, 15)
            
            HStack {
                Button("Cancel", action: {
                    NSApplication.shared.keyWindow?.close()
                })
                .keyboardShortcut(.cancelAction)
                
                Button("Save", action: {
                    bookModel.saveBook()
                    NSApplication.shared.keyWindow?.close()
                })
                .keyboardShortcut(.defaultAction)
            }
        }
        .padding(.horizontal, 15)
        .padding(.leading, 15)
        .frame(minWidth: 700)
    }
}

struct MacNewBookWindowView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        Group {
            MacNewBookWindowView().preferredColorScheme(.dark).environment(\.managedObjectContext, context)
        }
    }
}
