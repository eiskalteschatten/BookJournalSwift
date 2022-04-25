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
    @ObservedObject var book: Book

    @State private var screen: Screen?
    @State private var presentCloseAlert = false
    @State private var presentImagePicker = false
    @State private var imagePickerSourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var bookcoverUIImage = UIImage()
    @State private var addDateStarted = false
    @State private var addDateFinished = false

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
                            if let bookcover = book.bookcover {
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
                                selectedImageData: $book.bookcover
                            )
                        }
                        
                        // Title
                        TextField(
                            "Enter title...",
                            text: $book.title.toUnwrapped(defaultValue: "")
                        )
                            .font(.system(size: 20, weight: .bold))
                            .multilineTextAlignment(.center)
                            .padding(.bottom)
                    }
                }
                
                Group {
                    Section("Rating") {
                        BookRatingEditor(rating: $book.rating)
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                    
                    Section("Wishlist") {
                        // Wishlist
                        Toggle("Add Book to Wishlist", isOn: $book.onWishlist)
                    }
                }
                
                Section("Book Status") {
                    // Reading Status
                    Picker("Reading Status", selection: $book.readingStatus) {
                        ForEach(BookReadingStatus.allCases) { status in
                            Text(bookReadingStatusProperties[status]!)
                                .tag(status.rawValue)
                        }
                    }
                    
                    // Date Started
                    Toggle("Add Date Started", isOn: $addDateStarted.animation())
                    
                    if addDateStarted {
                        DatePicker(selection: $book.dateStarted.toUnwrapped(defaultValue: Date()), displayedComponents: .date) {
                            Text("Date Started:")
                        }
                        .transition(.scale)
                    }
                    
                    // Date Finished
                    Toggle("Add Date Finished", isOn: $addDateFinished.animation())
                
                    if addDateFinished {
                        DatePicker(selection: $book.dateFinished.toUnwrapped(defaultValue: Date()), displayedComponents: .date) {
                            Text("Date Finished:")
                        }
                        .transition(.scale)
                    }
                }
                
                Section("People") {
                    // Authors
                    NavigationLink(
                        destination: AuthorsSearchList(selectedItems: $book.authors),
                        tag: Screen.addAuthors,
                        selection: $screen,
                        label: { WrappingSmallChipsWithName<Author>(title: "Authors", data: book.authors, chipColor: AUTHOR_COLOR, alignment: .leading) }
                    )
                    
                    // Editors
                    NavigationLink(
                        destination: EditorsSearchList(selectedItems: $book.editors),
                        tag: Screen.addEditors,
                        selection: $screen,
                        label: { WrappingSmallChipsWithName<Editor>(title: "Editors", data: book.editors, chipColor: EDITOR_COLOR, alignment: .leading) }
                    )
                }
                
                Section("Categorization") {
                    // Categories
                    NavigationLink(
                        destination: CategoriesSearchList(selectedItems: $book.categories),
                        tag: Screen.addCategories,
                        selection: $screen,
                        label: { WrappingSmallChipsWithName<Category>(title: "Categories", data: book.categories, chipColor: CATEGORY_COLOR, alignment: .leading) }
                    )
                    
                    // Tags
                    NavigationLink(
                        destination: TagsSearchList(selectedItems: $book.tags),
                        tag: Screen.addTags,
                        selection: $screen,
                        label: { WrappingSmallChipsWithName<Tag>(title: "Tags", data: book.tags, chipColor: TAG_COLOR, alignment: .leading) }
                    )
                    
                    // Genres
                    NavigationLink(
                        destination: GenresSearchList(selectedItems: $book.genres),
                        tag: Screen.addGenres,
                        selection: $screen,
                        label: { WrappingSmallChipsWithName<Genre>(title: "Genres", data: book.genres, chipColor: GENRE_COLOR, alignment: .leading) }
                    )
                }
                
                Section("Publication Details") {
                    // Publisher
                    NavigationLink(
                        destination: PublishersSearchList(selectedItem: $book.publisher),
                        tag: Screen.addPublisher,
                        selection: $screen,
                        label: { PickerMimickerWithName<Publisher>(title: "Publisher", data: book.publisher) }
                    )
                    
                    // Book Format
                    Picker("Book Format", selection: $book.bookFormat) {
                        ForEach(BookFormat.allCases) { format in
                            Label(bookFormatProperties[format]![0], systemImage: bookFormatProperties[format]![1])
                                .tag(format.rawValue)
                        }
                    }
                    
                    // Year Published
                    TextField(
                        "Year Published",
                        value: $book.yearPublished,
                        format: .number
                    )
                        .keyboardType(.numberPad)
                    
                    // ISBN
                    TextField(
                        "ISBN",
                        text: $book.isbn.toUnwrapped(defaultValue: "")
                    )
                        .keyboardType(.numberPad)
                    
                    // Page Count
                    TextField(
                        "Page Count",
                        value: $book.pageCount,
                        format: .number
                    )
                        .keyboardType(.numberPad)
                }
                
                Section("World") {
                    // Country of Origin
                    NavigationLink(
                        destination: CountriesSearchList(selectedItem: $book.countryOfOrigin),
                        tag: Screen.addCountryOfOrigin,
                        selection: $screen,
                        label: { PickerMimickerWithName<Country>(title: "Country of Origin", data: book.countryOfOrigin) }
                    )
                    
                    // Translators
                    NavigationLink(
                        destination: TranslatorsSearchList(selectedItems: $book.translators),
                        tag: Screen.addTranslators,
                        selection: $screen,
                        label: { WrappingSmallChipsWithName<Translator>(title: "Translators", data: book.translators, chipColor: TRANSLATOR_COLOR, alignment: .leading) }
                    )
                    
                    LanguagePicker(title: "Original Language", selection: $book.originalLanguage.toUnwrapped(defaultValue: ""))
                    LanguagePicker(title: "Language Read In", selection: $book.languageReadIn.toUnwrapped(defaultValue: ""))
                }
                
                Group {
                    Section("Summary") {
                        // Summary
                        TextEditor(text: $book.summary.toUnwrapped(defaultValue: ""))
                    }
                    
                    Section("Commentary") {
                        // Commentary
                        TextEditor(text: $book.commentary.toUnwrapped(defaultValue: ""))
                    }
                     
                    Section("Notes") {
                        // Notes
                        TextEditor(text: $book.notes.toUnwrapped(defaultValue: ""))
                    }
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
                        do {
                            if viewContext!.hasChanges {
                                try viewContext!.save()
                            }
                            
                            dismiss()
                        } catch {
                            // TODO: Replace this implementation with code to handle the error appropriately.
                            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                            let nsError = error as NSError
                            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                        }
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
            iOSEditBookSheet(book: Book(context: context))
                .preferredColorScheme(.dark)
                .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                .frame(height: /*@START_MENU_TOKEN@*/800.0/*@END_MENU_TOKEN@*/)
                .environment(\.managedObjectContext, context)
        }
    }
}
