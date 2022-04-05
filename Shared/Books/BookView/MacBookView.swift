//
//  MacBookView.swift
//  BookJournal (macOS)
//
//  Created by Alex Seifert on 20.02.22.
//

import SwiftUI
import CoreData

struct MacBookView: View {
    var book: Book?
    
    var body: some View {
        VStack {
            if let unwrappedBook = book {
                let bookcover = getBookcover(book: unwrappedBook)
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
                                    BookViewBookCoverTitle(bookcover: bookcover, title: unwrappedBook.title!)
                                    BookViewAuthors(authors: unwrappedBook.sortedAuthors)
                                }
                                
                                BookRating(rating: Int(unwrappedBook.rating))
                                    .padding(.bottom, 10)
                                
                                Label("On Wishlist", systemImage: unwrappedBook.onWishlist ? "checkmark.square.fill" : "square")
                                    .padding(.bottom)
                                
                                Spacer()
                                
                                Group {
                                    let width = metrics.size.width * 0.15
                                    
                                    HStack(spacing: textWithLabelSpacing) {
                                        BookViewTextWithLabel(label: "Page Count", text: unwrappedBook.pageCount > 0 ? String(unwrappedBook.pageCount) : "")
                                            .frame(width: width)
                                        BookViewTextWithLabel(label: "Reading Status", text: unwrappedBook.readingStatusString ?? "")
                                            .frame(width: width)
                                        BookViewTextWithLabel(label: "Date Started", text: unwrappedBook.dateStartedFormatted)
                                            .frame(width: width)
                                        BookViewTextWithLabel(label: "Date Finished", text: unwrappedBook.dateFinishedFormatted)
                                            .frame(width: width)
                                    }
                                    
                                    HStack(spacing: textWithLabelSpacing) {
                                        BookViewTextWithLabel(label: "Book Format", text: unwrappedBook.bookFormatStrings[0])
                                            .frame(width: width)
                                        BookViewTextWithLabel(label: "Publisher", text: unwrappedBook.publisher?.name ?? "")
                                            .frame(width: width)
                                        BookViewTextWithLabel(label: "Year Published", text: unwrappedBook.yearPublished > 0 ? String(unwrappedBook.yearPublished) : "")
                                            .frame(width: width)
                                        BookViewTextWithLabel(label: "ISBN", text: unwrappedBook.isbn ?? "")
                                            .frame(width: width)
                                    }
                                }
                                
                                Spacer()
                                
                                Group {
                                    HStack(alignment: .top, spacing: groupBoxSpacing) {
                                        MacBookViewGroupBox(title: "Editors", icon: "person.2.wave.2", width: groupBoxWidth) {
                                            if unwrappedBook.editors != nil && unwrappedBook.sortedEditors.count > 0 {
                                                WrappingSmallChipsWithName<Editor>(data: unwrappedBook.sortedEditors, chipColor: EDITOR_COLOR, alignment: .leading)
                                            }
                                            else {
                                                Text("No editors selected")
                                            }
                                        }
                                        
                                        MacBookViewGroupBox(title: "Genres", icon: "text.book.closed", width: groupBoxWidth) {
                                            if unwrappedBook.genres != nil && unwrappedBook.sortedGenres.count > 0 {
                                                WrappingSmallChipsWithName<Genre>(data: unwrappedBook.sortedGenres, chipColor: GENRE_COLOR, alignment: .leading)
                                            }
                                            else {
                                                Text("No genres selected")
                                            }
                                        }
                                    }
                                    
                                    HStack(alignment: .top, spacing: groupBoxSpacing) {
                                        MacBookViewGroupBox(title: "Categories", icon: "folder", width: groupBoxWidth) {
                                            if unwrappedBook.categories != nil && unwrappedBook.sortedCategories.count > 0 {
                                                WrappingSmallChipsWithName<Category>(data: unwrappedBook.sortedCategories, chipColor: CATEGORY_COLOR, alignment: .leading)
                                            }
                                            else {
                                                Text("No categories selected")
                                            }
                                        }
                                        
                                        MacBookViewGroupBox(title: "Tags", icon: "tag", width: groupBoxWidth) {
                                            if let unwrappedTags = unwrappedBook.tags {
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
                                            if unwrappedBook.translators != nil && unwrappedBook.sortedTranslators.count > 0 {
                                                WrappingSmallChipsWithName<Translator>(data: unwrappedBook.sortedTranslators, chipColor: TRANSLATOR_COLOR, alignment: .leading)
                                            }
                                            else {
                                                Text("No translators selected")
                                            }
                                        }
                                        
                                        MacBookViewGroupBox(title: "World", icon: "globe", width: groupBoxWidth) {
                                            HStack(spacing: 20) {
                                                BookViewTextWithLabel(label: "Language Read In", text: unwrappedBook.languageReadInLocalizedName)
                                                BookViewTextWithLabel(label: "Original Language", text: unwrappedBook.originalLanguageLocalizedName)
                                                BookViewTextWithLabel(label: "Country of Origin", text: unwrappedBook.countryOfOrigin?.name ?? "")
                                            }
                                        }
                                    }
                                }
                                
                                Group {
                                    MacBookViewGroupBox(title: "Summary", icon: "text.alignleft", width: maxWidth) {
                                        if let unwrappedSummary = unwrappedBook.summary {
                                            Text(unwrappedSummary)
                                        }
                                    }
                                    
                                    MacBookViewGroupBox(title: "Commentary", icon: "text.bubble", width: maxWidth) {
                                        if let unwrappedCommentary = unwrappedBook.commentary {
                                            Text(unwrappedCommentary)
                                        }
                                    }
                                    
                                    MacBookViewGroupBox(title: "Notes", icon: "note.text", width: maxWidth) {
                                        if let unwrappedNotes = unwrappedBook.notes {
                                            Text(unwrappedNotes)
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
            else {
                // TODO: show a monochrome version of the app icon
                Image(systemName: "book")
                    .font(.system(size: 200))
                    .opacity(0.1)
            }
        }
        .toolbar {
            ToolbarItem {
                Button(action: editBook) {
                    Label("Edit", systemImage: "pencil")
                }
                .disabled(book == nil)
            }
            ToolbarItem {
                Button(action: deleteBooks) {
                    Label("Delete", systemImage: "trash")
                }
                .disabled(book == nil)
            }
        }
    }
    
    private func editBook() {
        // TODO
    }
    
    private func deleteBooks() {
        // TODO
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
