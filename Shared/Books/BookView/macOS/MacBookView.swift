//
//  MacBookView.swift
//  BookJournal (macOS)
//
//  Created by Alex Seifert on 20.02.22.
//

import SwiftUI

struct MacBookView: View {
    @ObservedObject var book: Book
    
    var body: some View {
        VStack {
            let bookcover = getBookcover(book: book)
            let offset = 100.0
            let maxWidth = 800.0
            let textWithLabelSpacing = 50.0
            let groupBoxSpacing = 20.0
            let groupBoxWidth = (maxWidth / 2) - (groupBoxSpacing / 2)
            
            GeometryReader { metrics in
                ScrollView {
                    ZStack {
                        BookViewBookCoverBlur(bookcover: bookcover)
                        
                        VStack(spacing: groupBoxSpacing) {
                            VStack(spacing: 10) {
                                BookViewBookCoverTitle(bookcover: bookcover, title: book.title)
                                BookViewAuthors(authors: book.sortedAuthors)
                            }
                            
                            BookRating(rating: Int(book.rating))
                                .padding(.bottom, 10)
                            
                            Label("On Wishlist", systemImage: book.onWishlist ? "checkmark.square.fill" : "square")
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
                                    MacBookViewGroupBox(title: "Editors", icon: "person.2.wave.2", width: groupBoxWidth) {
                                        if book.editors != nil && book.sortedEditors.count > 0 {
                                            WrappingSmallChipsWithName<Editor>(data: book.sortedEditors, chipColor: EDITOR_COLOR, alignment: .leading)
                                        }
                                        else {
                                            Text("No editors selected")
                                        }
                                    }
                                    
                                    MacBookViewGroupBox(title: "Genres", icon: "text.book.closed", width: groupBoxWidth) {
                                        if book.genres != nil && book.sortedGenres.count > 0 {
                                            WrappingSmallChipsWithName<Genre>(data: book.sortedGenres, chipColor: GENRE_COLOR, alignment: .leading)
                                        }
                                        else {
                                            Text("No genres selected")
                                        }
                                    }
                                }
                                
                                HStack(alignment: .top, spacing: groupBoxSpacing) {
                                    MacBookViewGroupBox(title: "Categories", icon: "folder", width: groupBoxWidth) {
                                        if book.categories != nil && book.sortedCategories.count > 0 {
                                            WrappingSmallChipsWithName<Category>(data: book.sortedCategories, chipColor: CATEGORY_COLOR, alignment: .leading)
                                        }
                                        else {
                                            Text("No categories selected")
                                        }
                                    }
                                    
                                    MacBookViewGroupBox(title: "Tags", icon: "tag", width: groupBoxWidth) {
                                        if let unwrappedTags = book.tags {
                                            if unwrappedTags.allObjects.count > 0 {
                                                WrappingSmallChipsWithName<Tag>(data: unwrappedTags.allObjects as! [Tag], chipColor: TAG_COLOR, alignment: .leading)
                                            }
                                            else {
                                                Text("No tags selected")
                                            }
                                        }
                                    }
                                }
                                
                                HStack(alignment: .top, spacing: groupBoxSpacing) {
                                    MacBookViewGroupBox(title: "Translators", icon: "person.2", width: groupBoxWidth) {
                                        if book.translators != nil && book.sortedTranslators.count > 0 {
                                            WrappingSmallChipsWithName<Translator>(data: book.sortedTranslators, chipColor: TRANSLATOR_COLOR, alignment: .leading)
                                        }
                                        else {
                                            Text("No translators selected")
                                        }
                                    }
                                    
                                    MacBookViewGroupBox(title: "World", icon: "globe", width: groupBoxWidth) {
                                        HStack(spacing: 20) {
                                            BookViewTextWithLabel(label: "Language Read In", text: book.languageReadInLocalizedName)
                                            BookViewTextWithLabel(label: "Original Language", text: book.originalLanguageLocalizedName)
                                            BookViewTextWithLabel(label: "Country of Origin", text: book.countryOfOrigin?.name ?? "")
                                        }
                                    }
                                }
                            }
                            
                            Group {
                                MacBookViewGroupBox(title: "Summary", icon: "text.alignleft", width: maxWidth) {
                                    if let unwrappedSummary = book.summary {
                                        Text(unwrappedSummary)
                                    }
                                }
                                
                                MacBookViewGroupBox(title: "Commentary", icon: "text.bubble", width: maxWidth) {
                                    if let unwrappedCommentary = book.commentary {
                                        Text(unwrappedCommentary)
                                    }
                                }
                                
                                MacBookViewGroupBox(title: "Notes", icon: "note.text", width: maxWidth) {
                                    if let unwrappedNotes = book.notes {
                                        Text(unwrappedNotes)
                                    }
                                }
                            }
                            
                            if book.title != "" || book.isbn != "" {
                                Group {
                                    MacBookViewGroupBox(title: "Search for this book on...", icon: "link", width: maxWidth) {
                                        BookLinksView(book: book)
                                    }
                                }
                            }
                        }
                        .offset(y: offset)
                        .frame(maxWidth: maxWidth)
                        .padding()
                        .padding(.bottom, offset)
                    }
                }
            }
        }
    }
}

struct MacBookView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let book = context.registeredObjects.first(where: { $0 is Book }) as! Book
        
        Group {
            MacBookView(book: book).preferredColorScheme(.dark).padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/).frame(height: 2000).environment(\.managedObjectContext, context)
            MacBookView(book: book).preferredColorScheme(.light).padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/).frame(height: 2000.0).environment(\.managedObjectContext, context)
        }
    }
}
