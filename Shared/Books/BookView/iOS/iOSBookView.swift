//
//  iOSBookView.swift
//  BookJournal (iOS)
//
//  Created by Alex Seifert on 31.03.22.
//

import SwiftUI

struct iOSBookView: View {
    @EnvironmentObject private var globalViewModel: GlobalViewModel
    @Binding var showEditBookSheet: Bool
    
    var body: some View {
        if let book = globalViewModel.selectedBook {
            VStack {
                let offset = 100.0
                let textWithLabelSpacing = 50.0
                
                GeometryReader { metrics in
                    ScrollView {
                        ZStack {
                            BookViewBookCoverBlur(book: book)
                        
                            LazyVStack(spacing: 30) {
                                VStack(spacing: 10) {
                                    BookViewBookCoverTitle(book: book)
                                    BookViewAuthors(authors: book.sortedAuthors)
                                }
                                
                                BookRating(book: book)
                                    .padding(.bottom)
                                
                                Group {
                                    let width = metrics.size.width * 0.35
                                    
                                    HStack(spacing: textWithLabelSpacing) {
                                        BookViewTextWithLabel(label: "Page Count", text: book.pageCount > 0 ? String(book.pageCount) : "")
                                            .frame(width: width)
                                        BookViewTextWithLabel(label: "Reading Status", text: book.readingStatusString ?? "")
                                            .frame(width: width)
                                    }

                                    HStack(spacing: textWithLabelSpacing) {
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
                                    }
                                    
                                    HStack(spacing: textWithLabelSpacing) {
                                        BookViewTextWithLabel(label: "Year Published", text: book.yearPublished > 0 ? String(book.yearPublished) : "")
                                            .frame(width: width)
                                        BookViewTextWithLabel(label: "ISBN", text: book.isbn ?? "")
                                            .frame(width: width)
                                    }
                                }
                                
                                Spacer()
                                
                                Group {
                                    iOSBookViewGroupBox(title: "Editors", icon: "person.2.wave.2") {
                                        if book.editors != nil && book.sortedEditors.count > 0 {
                                            WrappingSmallChipsWithName<Editor>(data: book.sortedEditors, chipColor: EDITOR_COLOR, alignment: .leading)
                                        }
                                        else {
                                            Text("No editors selected")
                                        }
                                    }
                                    
                                    iOSBookViewGroupBox(title: "Genres", icon: "text.book.closed") {
                                        if book.genres != nil && book.sortedGenres.count > 0 {
                                            WrappingSmallChipsWithName<Genre>(data: book.sortedGenres, chipColor: GENRE_COLOR, alignment: .leading)
                                        }
                                        else {
                                            Text("No genres selected")
                                        }
                                    }

                                    iOSBookViewGroupBox(title: "Lists", icon: "list.bullet.rectangle") {
                                        if book.lists != nil && book.sortedLists.count > 0 {
                                            WrappingSmallChipsWithName<ListOfBooks>(data: book.sortedLists, chipColor: LIST_COLOR, alignment: .leading)
                                        }
                                        else {
                                            Text("No lists selected")
                                        }
                                    }
                                    
                                    iOSBookViewGroupBox(title: "Tags", icon: "tag") {
                                        if let unwrappedTags = book.tags {
                                            if unwrappedTags.allObjects.count > 0 {
                                                WrappingSmallChipsWithName<Tag>(data: unwrappedTags.allObjects as! [Tag], chipColor: TAG_COLOR, alignment: .leading)
                                            }
                                            else {
                                                Text("No tags selected")
                                            }
                                        }
                                    }
                                    
                                    iOSBookViewGroupBox(title: "Translators", icon: "person.2") {
                                        if book.translators != nil && book.sortedTranslators.count > 0 {
                                            WrappingSmallChipsWithName<Translator>(data: book.sortedTranslators, chipColor: TRANSLATOR_COLOR, alignment: .leading)
                                        }
                                        else {
                                            Text("No translators selected")
                                        }
                                    }
                                    
                                    iOSBookViewGroupBox(title: "World", icon: "globe") {
                                        VStack(alignment: .leading, spacing: 20) {
                                            HStack(spacing: 20) {
                                                BookViewTextWithLabel(label: "Language Read In", text: book.languageReadInLocalizedName)
                                                BookViewTextWithLabel(label: "Original Language", text: book.originalLanguageLocalizedName)
                                            }
                                            BookViewTextWithLabel(label: "Country of Origin", text: book.countryOfOrigin?.name ?? "")
                                        }
                                    }
                                }
                                
                                Group {
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

struct iOSBookView_Previews: PreviewProvider {
    @State static var showEditBookSheet = false
    
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        
        iOSBookView(showEditBookSheet: $showEditBookSheet).preferredColorScheme(.dark).environment(\.managedObjectContext, context)
    }
}

