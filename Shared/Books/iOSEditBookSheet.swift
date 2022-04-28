//
//  iOSEditBookSheet.swift
//  BookJournal (iOS)
//
//  Created by Alex Seifert on 25.02.22.
//

import SwiftUI
import UIKit
import CoreData
import WrappingHStack

struct iOSEditBookSheet: View {
    private enum Screen: Int {
        case addAuthors, addEditors, addGenres, addCategories, addTags, addTranslators, addPublisher, addCountryOfOrigin
    }
    
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject private var bookModel: BookModel

    @State private var screen: Screen?
    @State private var presentCloseAlert = false
    @State private var presentImagePicker = false
    @State private var imagePickerSourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var bookcoverUIImage = UIImage()
    
    private var sheetTitle: String = "Add a New Book"
    
    init(
        book: Book? = nil,
        createOptions: BookModelCreateOptions? = nil
    ) {
        bookModel = BookModel(book: book, createOptions: createOptions)
        
        if let title = book?.title {
            sheetTitle = "Edit \(title)"
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("Book Cover & Title") {
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
                            if let bookcover = bookModel.bookcover {
                                let image = UIImage(data: bookcover)
                                Image(uiImage: image!)
                                    .resizable()
                                    .scaledToFit()
                            }
                            else {
                                Image(systemName: "plus.square.dashed")
                                    .font(.system(size: 150))
                            }
                        }
                        .padding(.vertical)
                        .sheet(isPresented: $presentImagePicker) {
                            ImagePicker(
                                sourceType: imagePickerSourceType,
                                selectedImage: $bookcoverUIImage,
                                selectedImageData: $bookModel.bookcover
                            )
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
                
                Group {
                    Section("Rating") {
                        BookRatingEditor(rating: $bookModel.rating)
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                    
                    Section("Wishlist") {
                        // Wishlist
                        Toggle("Add Book to Wishlist", isOn: $bookModel.onWishlist)
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
                        destination: SearchListNamedElement<Author>(
                            title: "Authors",
                            selectedData: $bookModel.authors,
                            createTitle: "Create an Author"
                        ),
                        tag: Screen.addAuthors,
                        selection: $screen,
                        label: { WrappingSmallChipsWithName<Author>(title: "Authors", data: bookModel.authors, chipColor: AUTHOR_COLOR, alignment: .leading) }
                    )
                    
                    // Editors
                    NavigationLink(
                        destination: SearchListNamedElement<Editor>(
                            title: "Editors",
                            selectedData: $bookModel.editors,
                            createTitle: "Create an Editor"
                        ),
                        tag: Screen.addEditors,
                        selection: $screen,
                        label: { WrappingSmallChipsWithName<Editor>(title: "Editors", data: bookModel.editors, chipColor: EDITOR_COLOR, alignment: .leading) }
                    )
                }
                
                Section("Categorization") {
                    // Categories
                    NavigationLink(
                        destination: SearchListNamedElement<Category>(
                            title: "Categories",
                            selectedData: $bookModel.categories,
                            createTitle: "Create a Category"
                        ),
                        tag: Screen.addCategories,
                        selection: $screen,
                        label: { WrappingSmallChipsWithName<Category>(title: "Categories", data: bookModel.categories, chipColor: CATEGORY_COLOR, alignment: .leading) }
                    )
                    
                    // Tags
                    NavigationLink(
                        destination: SearchListNamedElement<Tag>(
                            title: "Tags",
                            selectedData: $bookModel.tags,
                            createTitle: "Create a Tag"
                        ),
                        tag: Screen.addTags,
                        selection: $screen,
                        label: { WrappingSmallChipsWithName<Tag>(title: "Tags", data: bookModel.tags, chipColor: TAG_COLOR, alignment: .leading) }
                    )
                    
                    // Genres
                    NavigationLink(
                        destination: SearchListNamedElement<Genre>(
                            title: "Genres",
                            selectedData: $bookModel.genres,
                            createTitle: "Create a Genre"
                        ),
                        tag: Screen.addGenres,
                        selection: $screen,
                        label: { WrappingSmallChipsWithName<Genre>(title: "Genres", data: bookModel.genres, chipColor: GENRE_COLOR, alignment: .leading) }
                    )
                }
                
                Section("Publication Details") {
                    // Publisher
                    NavigationLink(
                        destination: SearchListNamedElement<Publisher>(
                            title: "Publisher",
                            selectedData: $bookModel.publisher,
                            createTitle: "Create a Publisher"
                        ),
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
                        destination: SearchListNamedElement<Country>(
                            title: "Country of Origin",
                            selectedData: $bookModel.countryOfOrigin,
                            createTitle: "Create a Country"
                        ),
                        tag: Screen.addCountryOfOrigin,
                        selection: $screen,
                        label: { PickerMimickerWithName<Country>(title: "Country of Origin", data: bookModel.countryOfOrigin) }
                    )
                    
                    // Translators
                    NavigationLink(
                        destination: SearchListNamedElement<Translator>(
                            title: "Translators",
                            selectedData: $bookModel.translators,
                            createTitle: "Create a Translator"
                        ),
                        tag: Screen.addTranslators,
                        selection: $screen,
                        label: { WrappingSmallChipsWithName<Translator>(title: "Translators", data: bookModel.translators, chipColor: TRANSLATOR_COLOR, alignment: .leading) }
                    )
                    
                    LanguagePicker(title: "Original Language", selection: $bookModel.originalLanguage)
                    LanguagePicker(title: "Language Read In", selection: $bookModel.languageReadIn)
                }
                
                Group {
                    Section("Summary") {
                        // Summary
                        TextEditor(text: $bookModel.summary)
                    }
                    
                    Section("Commentary") {
                        // Commentary
                        TextEditor(text: $bookModel.commentary)
                    }
                     
                    Section("Notes") {
                        // Notes
                        TextEditor(text: $bookModel.notes)
                    }
                }
            }
            .alert("Are you sure you want to cancel?", isPresented: $presentCloseAlert, actions: {
                Button("No", role: .cancel, action: { presentCloseAlert = false })
                Button("Yes", role: .destructive, action: { dismiss() })
            }, message: {
                Text("Your changes will be lost if you continue.")
            })
            .navigationBarTitle(Text(sheetTitle), displayMode: .inline)
                .navigationBarItems(
                    leading: Button(action: {
                        presentCloseAlert = true
                    }) {
                        Text("Cancel")
                    },
                    trailing: Button(action: {
                        bookModel.save()
                        dismiss()
                    }) {
                        Text("Save").bold()
                    }
                )
        }
    }
}

struct iOSEditBookSheet_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        Group {
            iOSEditBookSheet()
                .preferredColorScheme(.dark)
                .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                .frame(height: /*@START_MENU_TOKEN@*/800.0/*@END_MENU_TOKEN@*/)
                .environment(\.managedObjectContext, context)
        }
    }
}
