//
//  iOSNewBookSheet.swift
//  BookJournal (iOS)
//
//  Created by Alex Seifert on 25.02.22.
//

import SwiftUI
import UIKit
import CoreData
import WrappingHStack

struct iOSNewBookSheet: View {
    private enum Screen: Int {
        case addAuthors, addEditors, addGenres, addCategories, addTags, addTranslators, addPublisher, addCountryOfOrigin
    }
    
    @Environment(\.dismiss) var dismiss

    @State private var screen: Screen?
    @StateObject private var bookModel = BookModel()
    @State private var presentCloseAlert = false
    @State private var presentImagePicker = false
    @State private var imagePickerSourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var bookcoverUIImage = UIImage()

    var body: some View {
        NavigationView {
            Form {
                Section("Bookcover & Title") {
                    VStack(alignment: .center) {
                        // Bookcover
                        Menu {
                            Button(action: {
                                imagePickerSourceType = .photoLibrary
                                presentImagePicker = true
                            }) {
                                Label("Choose Image", systemImage: "photo")
                            }
                            
                            Button(action: {
                                imagePickerSourceType = .camera
                                presentImagePicker = true
                            }) {
                                Label("Scan Image", systemImage: "viewfinder")
                            }
                        } label: {
                            Image(systemName: "plus.square.dashed")
                                .font(.system(size: 150))
                        }
                        .padding(.vertical)
                        .sheet(isPresented: $presentImagePicker) {
                            ImagePicker(sourceType: imagePickerSourceType, selectedImage: $bookcoverUIImage)
                        }
                        
                        // Title
                        TextField(
                            "Enter title...",
                            text: $bookModel.title
                        )
                            .font(.system(size: 20, weight: .bold))
                            .multilineTextAlignment(.center)
                            .padding(.bottom)
                    }
                }
                
                Section("Book Status") {
                    // Reading Status
                    Picker("Reading Status", selection: $bookModel.readingStatus) {
                        ForEach(BookReadingStatus.allCases) { status in
                            Text(bookReadingStatusProperties[status]!)
                                .tag(status.rawValue)
                        }
                    }
                    
                    // Date Started
                    Toggle("Add Date Started", isOn: $bookModel.addDateStarted.animation())
                    
                    if bookModel.addDateStarted {
                        DatePicker(selection: $bookModel.dateStarted, displayedComponents: .date) {
                            Text("Date Started:")
                        }
                        .transition(.scale)
                    }
                    
                    // Date Finished
                    Toggle("Add Date Finished", isOn: $bookModel.addDateFinished.animation())
                
                    if bookModel.addDateFinished {
                        DatePicker(selection: $bookModel.dateFinished, displayedComponents: .date) {
                            Text("Date Finished:")
                        }
                        .transition(.scale)
                    }
                }
                
                Section("People") {
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
                }
                
                Section("Categorization") {
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
                    
                    // Genres
                    NavigationLink(
                        destination: GenresSearchList(selectedItems: $bookModel.genres),
                        tag: Screen.addGenres,
                        selection: $screen,
                        label: { WrappingSmallChipsWithName<Genre>(title: "Genres", data: bookModel.genres, chipColor: GENRE_COLOR) }
                    )
                }
                
                Section("Publication Details") {
                    // Publisher
                    NavigationLink(
                        destination: PublishersSearchList(selectedItem: $bookModel.publisher),
                        tag: Screen.addPublisher,
                        selection: $screen,
                        label: { PickerMimickerWithName<Publisher>(title: "Publisher", data: bookModel.publisher) }
                    )
                    
                    // Book Format
                    Picker("Book Format", selection: $bookModel.bookFormat) {
                        ForEach(BookFormat.allCases) { format in
                            Label(bookFormatProperties[format]![0], systemImage: bookFormatProperties[format]![1])
                                .tag(format.rawValue)
                        }
                    }
                    
                    // Year Published
                    TextField(
                        "Year Published",
                        value: $bookModel.yearPublished,
                        format: .number
                    )
                        .keyboardType(.numberPad)
                    
                    // ISBN
                    TextField(
                        "ISBN",
                        text: $bookModel.isbn
                    )
                        .keyboardType(.numberPad)
                    
                    // Page Count
                    TextField(
                        "Page Count",
                        value: $bookModel.pageCount,
                        format: .number
                    )
                        .keyboardType(.numberPad)
                }
                
                Section("World") {
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
            .alert("Are you sure you want to cancel?", isPresented: $presentCloseAlert, actions: {
                Button("No", role: .cancel, action: { presentCloseAlert = false })
                Button("Yes", role: .destructive, action: { dismiss() })
            }, message: {
                Text("Your changes will be lost if you continue.")
            })
            .navigationBarTitle(Text("Add a New Book"), displayMode: .inline)
                .navigationBarItems(
                    leading: Button(action: {
                        presentCloseAlert = true
                    }) {
                        Text("Cancel")
                    },
                    trailing: Button(action: {
                        bookModel.saveBook()
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
