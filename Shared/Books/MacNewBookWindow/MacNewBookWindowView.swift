//
//  MacNewBookWindowView.swift
//  BookJournal (macOS)
//
//  Created by Alex Seifert on 25.02.22.
//

import SwiftUI

enum MacNewBookWindowViewScreen: Int, CaseIterable {
    case step1, step2, step3, step4, step5, step6
}

struct MacNewBookWindowView: View {
    @State private var screen: MacNewBookWindowViewScreen = .step1
    @StateObject private var bookModel = BookModel()
    
    private let lastStep: MacNewBookWindowViewScreen = .step6
    
    var body: some View {
        VStack {
            Group {
                switch screen {
                case .step1:
                    MacNewBookStep1(bookModel: bookModel)
                case .step2:
                    MacNewBookStep2(bookModel: bookModel)
                default:
                    MacNewBookStep1(bookModel: bookModel)
                }
            }
            .frame(maxHeight: .infinity)
            
                // People
//                Group {
//                    // Authors
//                    NavigationLink(
//                        destination: AuthorsSearchList(selectedItems: $bookModel.authors),
//                        tag: Screen.addAuthors,
//                        selection: $screen,
//                        label: { WrappingSmallChipsWithName<Author>(title: "Authors", data: bookModel.authors, chipColor: AUTHOR_COLOR) }
//                    )
//
//                    // Editors
//                    NavigationLink(
//                        destination: EditorsSearchList(selectedItems: $bookModel.editors),
//                        tag: Screen.addEditors,
//                        selection: $screen,
//                        label: { WrappingSmallChipsWithName<Editor>(title: "Editors", data: bookModel.editors, chipColor: EDITOR_COLOR) }
//                    )
//
//                    Divider()
//                        .padding(.vertical, spacerHeight)
//                }
                
                // Book Information
//                Group {
//                    // Page Count
//                    TextField(
//                        "Page Count:",
//                        value: $bookModel.pageCount,
//                        format: .number
//                    )
//
//                    // Genres
//                    NavigationLink(
//                        destination: GenresSearchList(selectedItems: $bookModel.genres),
//                        tag: Screen.addGenres,
//                        selection: $screen,
//                        label: { WrappingSmallChipsWithName<Genre>(title: "Genres", data: bookModel.genres, chipColor: GENRE_COLOR) }
//                    )
//
//                    // Categories
//                    NavigationLink(
//                        destination: CategoriesSearchList(selectedItems: $bookModel.categories),
//                        tag: Screen.addCategories,
//                        selection: $screen,
//                        label: { WrappingSmallChipsWithName<Category>(title: "Categories", data: bookModel.categories, chipColor: CATEGORY_COLOR) }
//                    )
//
//                    // Tags
//                    NavigationLink(
//                        destination: TagsSearchList(selectedItems: $bookModel.tags),
//                        tag: Screen.addTags,
//                        selection: $screen,
//                        label: { WrappingSmallChipsWithName<Tag>(title: "Tags", data: bookModel.tags, chipColor: TAG_COLOR) }
//                    )
//
//                    Divider()
//                        .padding(.vertical, spacerHeight)
//                }
                    
//                Group {
//                    // Book Format
//                    Picker("Book Format:", selection: $bookModel.bookFormat) {
//                        ForEach(BookFormat.allCases) { format in
//                            Label(bookFormatProperties[format]![0], systemImage: bookFormatProperties[format]![1])
//                                .tag(format.rawValue)
//                        }
//                    }
//
//                    // Publisher
//                    NavigationLink(
//                        destination: PublishersSearchList(selectedItem: $bookModel.publisher),
//                        tag: Screen.addPublisher,
//                        selection: $screen,
//                        label: { PickerMimickerWithName<Publisher>(title: "Publisher", data: bookModel.publisher) }
//                    )
//
//                    // Year Published
//                    TextField(
//                        "Year Published:",
//                        value: $bookModel.yearPublished,
//                        format: .number
//                    )
//
//                    // ISBN
//                    TextField(
//                        "ISBN:",
//                        text: $bookModel.isbn
//                    )
//
//                    Divider()
//                        .padding(.vertical, spacerHeight)
//                }
                
                // World
//                Group {
//                    // Country of Origin
//                    NavigationLink(
//                        destination: CountriesSearchList(selectedItem: $bookModel.countryOfOrigin),
//                        tag: Screen.addCountryOfOrigin,
//                        selection: $screen,
//                        label: { PickerMimickerWithName<Country>(title: "Country of Origin", data: bookModel.countryOfOrigin) }
//                    )
//    
//                    // Translators
//                    NavigationLink(
//                        destination: TranslatorsSearchList(selectedItems: $bookModel.translators),
//                        tag: Screen.addTranslators,
//                        selection: $screen,
//                        label: { WrappingSmallChipsWithName<Translator>(title: "Translators", data: bookModel.translators, chipColor: TRANSLATOR_COLOR) }
//                    )
//    
//                        LanguagePicker(title: "Original Language", selection: $bookModel.originalLanguage)
//                        LanguagePicker(title: "Language Read In", selection: $bookModel.languageReadIn)
//                }
//            }
//            .padding(.bottom, 15)
            
            HStack {
                ForEach(MacNewBookWindowViewScreen.allCases, id: \.self) { step in
                    let imageName = screen.rawValue == step.rawValue ? "circle.fill" : "circle"
                    Image(systemName: imageName)
                        .font(.system(size: 7))
                }
            }
            .padding(.vertical)
            
            HStack {
                Button("Cancel", action: {
                    NSApplication.shared.keyWindow?.close()
                })
                .keyboardShortcut(.cancelAction)
                
                Spacer()
                
                if screen != lastStep {
                    if screen != .step1 {
                        Button("Previous", action: goToPrevStep)
                    }
                    
                    Button("Next", action: goToNextStep)
                    .keyboardShortcut(.defaultAction)
                }
                else {
                    Button("Finish", action: {
                        bookModel.saveBook()
                        NSApplication.shared.keyWindow?.close()
                    })
                    .keyboardShortcut(.defaultAction)
                }
            }
        }
        .padding()
        .frame(minWidth: 450, minHeight: 500)
    }
    
    private func goToPrevStep() {
        if screen.rawValue > 0 {
            screen = MacNewBookWindowViewScreen.allCases[screen.rawValue - 1]
        }
    }
    
    private func goToNextStep() {
        if screen.rawValue < lastStep.rawValue {
            screen = MacNewBookWindowViewScreen.allCases[screen.rawValue + 1]
        }
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
