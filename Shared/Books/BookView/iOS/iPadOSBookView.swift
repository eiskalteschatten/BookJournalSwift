//
//  iPadOSBookView.swift
//  BookJournal (iOS)
//
//  Created by Alex Seifert on 03.04.22.
//

import SwiftUI

struct iPadOSBookView: View {
    @EnvironmentObject private var globalViewModel: GlobalViewModel
    @Binding var showEditBookSheet: Bool
    
    var body: some View {
        if let book = globalViewModel.selectedBook {
            VStack {
                let offset = 100.0
                let textWithLabelSpacing = 50.0
                let groupBoxSpacing = 20.0
                
                GeometryReader { metrics in
                    let groupBoxWidth = (metrics.size.width * 0.5) - groupBoxSpacing
                    
                    ScrollView {
                        ZStack {
                            BookViewBookCoverBlur(book: book)
                        
                            LazyVStack(spacing: 30) {
                                
                                VStack(spacing: 10) {
                                    BookViewBookCoverTitle(book: book)
                                    if book.authors != nil && book.sortedAuthors.count > 0 {
                                        WrappingSmallChipsWithName<Author>(book: book, chipColor: AUTHOR_COLOR)
                                    }
                                }
                                
                                BookRating(book: book)
                                    .padding(.bottom)
                                
                                Spacer()
                                
                                Group {
                                    let width = metrics.size.width * 0.15
                                    
                                    HStack(spacing: textWithLabelSpacing) {
                                        BookViewTextWithLabel(label: "Page Count", text: book.pageCount > 0 ? String(book.pageCount) : "")
                                            .frame(width: width)
                                        BookViewTextWithLabel(label: "Reading Status", text: book.readingStatusString ?? "")
                                            .frame(width: width)
                                        BookViewTextWithLabel(label: "Date Started", text: book.dateStartedFormatted)
                                            .frame(width: width)
                                        BookViewTextWithLabel(label: "Date Finished", text: book.dateFinishedFormatted)
                                            .frame(width: width)
                                    }
                                    
                                    HStack(spacing: textWithLabelSpacing) {
                                        BookViewTextWithLabel(label: "Book Format", text: book.bookFormatStrings[0])
                                            .frame(width: width)
                                        BookViewTextWithLabel(label: "Publisher", text: book.publisher?.name ?? "")
                                            .frame(width: width)
                                        BookViewTextWithLabel(label: "Year Published", text: book.yearPublished > 0 ? String(book.yearPublished) : "")
                                            .frame(width: width)
                                        BookViewTextWithLabel(label: "ISBN", text: book.isbn ?? "")
                                            .frame(width: width)
                                    }
                                }
                                
                                Spacer()
                                
                                Group {
                                    HStack(alignment: .top, spacing: groupBoxSpacing) {
                                        iOSBookViewGroupBox(title: "Editors", icon: "person.2.wave.2", width: groupBoxWidth) {
                                            if book.editors != nil && book.sortedEditors.count > 0 {
                                                WrappingSmallChipsWithName<Editor>(book: book, chipColor: EDITOR_COLOR, alignment: .leading)
                                            }
                                            else {
                                                Text("No editors selected")
                                            }
                                        }
                                        
                                        iOSBookViewGroupBox(title: "Genres", icon: "text.book.closed", width: groupBoxWidth) {
                                            if book.genres != nil && book.sortedGenres.count > 0 {
                                                WrappingSmallChipsWithName<Genre>(book: book, chipColor: GENRE_COLOR, alignment: .leading)
                                            }
                                            else {
                                                Text("No genres selected")
                                            }
                                        }
                                    }
                                    
                                    HStack(alignment: .top, spacing: groupBoxSpacing) {
                                        iOSBookViewGroupBox(title: "Lists", icon: "list.bullet.rectangle", width: groupBoxWidth) {
                                            if book.lists != nil && book.sortedLists.count > 0 {
                                                WrappingSmallChipsWithName<ListOfBooks>(book: book, chipColor: LIST_COLOR, alignment: .leading)
                                            }
                                            else {
                                                Text("No lists selected")
                                            }
                                        }
                                        
                                        iOSBookViewGroupBox(title: "Tags", icon: "tag", width: groupBoxWidth) {
                                            if let unwrappedTags = book.tags {
                                                if unwrappedTags.allObjects.count > 0 {
                                                    WrappingSmallChipsWithName<Tag>(book: book, chipColor: TAG_COLOR, alignment: .leading)
                                                }
                                                else {
                                                    Text("No tags selected")
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                Group {
                                    iOSBookViewGroupBox(title: "Translators", icon: "person.2") {
                                        if book.translators != nil && book.sortedTranslators.count > 0 {
                                            WrappingSmallChipsWithName<Translator>(book: book, chipColor: TRANSLATOR_COLOR, alignment: .leading)
                                        }
                                        else {
                                            Text("No translators selected")
                                        }
                                    }
                                    
                                    iOSBookViewGroupBox(title: "World", icon: "globe") {
                                        HStack(spacing: 20) {
                                            BookViewTextWithLabel(label: "Language Read In", text: book.languageReadInLocalizedName)
                                            BookViewTextWithLabel(label: "Original Language", text: book.originalLanguageLocalizedName)
                                            BookViewTextWithLabel(label: "Country of Origin", text: book.countryOfOrigin?.name ?? "")
                                        }
                                    }
                                    
                                    iOSBookViewGroupBox(title: "Summary", icon: "text.alignleft") {
                                        if let unwrappedSummary = book.summary {
                                            Text(unwrappedSummary)
                                                .textSelection(.enabled)
                                        }
                                    }
                                    
                                    iOSBookViewGroupBox(title: "Commentary", icon: "text.bubble") {
                                        if let unwrappedCommentary = book.commentary {
                                            Text(unwrappedCommentary)
                                                .textSelection(.enabled)
                                        }
                                    }
                                    
                                    iOSBookViewGroupBox(title: "Notes", icon: "note.text") {
                                        if let unwrappedNotes = book.notes {
                                            Text(unwrappedNotes)
                                                .textSelection(.enabled)
                                        }
                                    }
                                    
                                    if book.title != "" || book.isbn != "" {
                                        iOSBookViewGroupBox(title: "Search for this book on...", icon: "link") {
                                            BookLinksView(book: book)
                                        }
                                    }
                                }
                            }
                        }
                        .offset(y: offset)
                        .padding()
                        .padding(.bottom, offset)
                    }
                    .edgesIgnoringSafeArea(.top)
                }
            }
            .sheet(isPresented: $showEditBookSheet) {
                iOSEditBookSheet(book: book)
            }
        }
    }
}

struct iPadOSBookView_Previews: PreviewProvider {
    @State static var showEditBookSheet = false
    
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        
        iPadOSBookView(showEditBookSheet: $showEditBookSheet).preferredColorScheme(.dark).environment(\.managedObjectContext, context)
    }
}
