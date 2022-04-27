//
//  iOSBookView.swift
//  BookJournal (iOS)
//
//  Created by Alex Seifert on 31.03.22.
//

import SwiftUI

struct iOSBookView: View {
    @ObservedObject var book: Book
    @Binding var showEditBookSheet: Bool
    
    var body: some View {
        VStack {
            let bookcover = getBookcover(book: book)
            let offset = 100.0
            let textWithLabelSpacing = 50.0
            
            GeometryReader { metrics in
                ScrollView {
                    ZStack {
                        BookViewBookCoverBlur(bookcover: bookcover)
                    
                        VStack(spacing: 30) {
                            VStack(spacing: 10) {
                                BookViewBookCoverTitle(bookcover: bookcover, title: book.title)
                                BookViewAuthors(authors: book.sortedAuthors)
                            }
                            
                            BookRating(rating: Int(book.rating))
                                .padding(.bottom, 10)
                            
                            Label("On Wishlist", systemImage: book.onWishlist ? "checkmark.square.fill" : "square")
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

                                iOSBookViewGroupBox(title: "Categories", icon: "folder") {
                                    if book.categories != nil && book.sortedCategories.count > 0 {
                                        WrappingSmallChipsWithName<Category>(data: book.sortedCategories, chipColor: CATEGORY_COLOR, alignment: .leading)
                                    }
                                    else {
                                        Text("No categories selected")
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
                                    }
                                }
                                
                                iOSBookViewGroupBox(title: "Commentary", icon: "text.bubble") {
                                    if let unwrappedCommentary = book.commentary {
                                        Text(unwrappedCommentary)
                                    }
                                }
                                
                                iOSBookViewGroupBox(title: "Notes", icon: "note.text") {
                                    if let unwrappedNotes = book.notes {
                                        Text(unwrappedNotes)
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

struct iOSBookView_Previews: PreviewProvider {
    @State static var showEditBookSheet = false
    
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let book = context.registeredObjects.first(where: { $0 is Book }) as! Book
        
        iOSBookView(book: book, showEditBookSheet: $showEditBookSheet).preferredColorScheme(.dark).environment(\.managedObjectContext, context)
    }
}

