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
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var screen: Screen?
    @StateObject private var newBookFormModel = NewBookFormModel()
    
    var body: some View {
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
                        text: $newBookFormModel.title
                    )
                    
                    // Reading Status
                    Picker("Reading Status:", selection: $newBookFormModel.readingStatus) {
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
                                Text("Date Started:")
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
                                Text("Date Finished:")
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
                    
    //            // People
    //            Group {
    //                // Authors
    //                NavigationLink(
    //                    destination: AuthorsSearchList(selectedItems: $authors),
    //                    tag: Screen.addAuthors,
    //                    selection: $screen,
    //                    label: { WrappingSmallChipsWithName<Author>(title: "Authors", data: authors, chipColor: AUTHOR_COLOR) }
    //                )
    //
    //                // Editors
    //                NavigationLink(
    //                    destination: EditorsSearchList(selectedItems: $editors),
    //                    tag: Screen.addEditors,
    //                    selection: $screen,
    //                    label: { WrappingSmallChipsWithName<Editor>(title: "Editors", data: editors, chipColor: EDITOR_COLOR) }
    //                )
    //            }
                    
                // Book Information
                Group {
                    // Page Count
                    TextField(
                        "Page Count:",
                        value: $newBookFormModel.pageCount,
                        format: .number
                    )
                        
    //                // Genres
    //                NavigationLink(
    //                    destination: GenresSearchList(selectedItems: $genres),
    //                    tag: Screen.addGenres,
    //                    selection: $screen,
    //                    label: { WrappingSmallChipsWithName<Genre>(title: "Genres", data: genres, chipColor: GENRE_COLOR) }
    //                )
    //
    //                // Categories
    //                NavigationLink(
    //                    destination: CategoriesSearchList(selectedItems: $categories),
    //                    tag: Screen.addCategories,
    //                    selection: $screen,
    //                    label: { WrappingSmallChipsWithName<Category>(title: "Categories", data: categories, chipColor: CATEGORY_COLOR) }
    //                )
    //
    //                // Tags
    //                NavigationLink(
    //                    destination: TagsSearchList(selectedItems: $tags),
    //                    tag: Screen.addTags,
    //                    selection: $screen,
    //                    label: { WrappingSmallChipsWithName<Tag>(title: "Tags", data: tags, chipColor: TAG_COLOR) }
    //                )
                    }
                    
                Group {
                    // Book Format
                    Picker("Book Format:", selection: $newBookFormModel.bookFormat) {
                        ForEach(BookFormat.allCases) { format in
                            Label(bookFormatProperties[format]![0], systemImage: bookFormatProperties[format]![1])
                                .tag(format.rawValue)
                        }
                    }
                        
    //                // Publisher
    //                NavigationLink(
    //                    destination: PublishersSearchList(selectedItem: $publisher),
    //                    tag: Screen.addPublisher,
    //                    selection: $screen,
    //                    label: { PickerMimickerWithName<Publisher>(title: "Publisher", data: publisher) }
    //                )
                        
                    // Year Published
                    TextField(
                        "Year Published:",
                        value: $newBookFormModel.yearPublished,
                        format: .number
                    )
                    
                    // ISBN
                    TextField(
                        "ISBN:",
                        text: $newBookFormModel.isbn
                    )
                }
                    
                // World
    //            Group {
    //                // Country of Origin
    //                NavigationLink(
    //                    destination: CountriesSearchList(selectedItem: $countryOfOrigin),
    //                    tag: Screen.addCountryOfOrigin,
    //                    selection: $screen,
    //                    label: { PickerMimickerWithName<Country>(title: "Country of Origin", data: countryOfOrigin) }
    //                )
    //
    //                // Translators
    //                NavigationLink(
    //                    destination: TranslatorsSearchList(selectedItems: $translators),
    //                    tag: Screen.addTranslators,
    //                    selection: $screen,
    //                    label: { WrappingSmallChipsWithName<Translator>(title: "Translators", data: translators, chipColor: TRANSLATOR_COLOR) }
    //                )
    //
    //                LanguagePicker(title: "Original Language", selection: $originalLanguage)
    //                LanguagePicker(title: "Language Read In", selection: $languageReadIn)
    //            }
                
                HStack {
                    Button("Cancel", action: {
//                        dismiss()
                    })
                    Button("Save", action: {
                        newBookFormModel.saveBook()
//                        dismiss()
                    })
                }
            }
        }
        .padding(15)
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
