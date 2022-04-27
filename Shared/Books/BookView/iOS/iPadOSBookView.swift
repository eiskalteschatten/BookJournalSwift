//
//  iPadOSBookView.swift
//  BookJournal (iOS)
//
//  Created by Alex Seifert on 03.04.22.
//

import SwiftUI

struct iPadOSBookView: View {
    @ObservedObject var book: Book
    
    @State private var showEditBookSheet = false
    
    var body: some View {
        VStack {
            let bookcover = getBookcover(book: book)
            let offset = 100.0
            let textWithLabelSpacing = 50.0
            let groupBoxSpacing = 20.0
            
            GeometryReader { metrics in
                let groupBoxWidth = (metrics.size.width * 0.5) - groupBoxSpacing
                
                ScrollView {
                    ZStack {
                        BookViewBookCoverBlur(bookcover: bookcover)
                    
                        VStack(spacing: 30) {
                            
                            VStack(spacing: 10) {
                                BookViewBookCoverTitle(bookcover: bookcover, title: book.title!)
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
                                    iOSBookViewGroupBox(title: "Editors", icon: "person.2.wave.2", width: groupBoxWidth) {
                                        if book.editors != nil && book.sortedEditors.count > 0 {
                                            WrappingSmallChipsWithName<Editor>(data: book.sortedEditors, chipColor: EDITOR_COLOR, alignment: .leading)
                                        }
                                        else {
                                            Text("No editors selected")
                                        }
                                    }
                                    
                                    iOSBookViewGroupBox(title: "Genres", icon: "text.book.closed", width: groupBoxWidth) {
                                        if book.genres != nil && book.sortedGenres.count > 0 {
                                            WrappingSmallChipsWithName<Genre>(data: book.sortedGenres, chipColor: GENRE_COLOR, alignment: .leading)
                                        }
                                        else {
                                            Text("No genres selected")
                                        }
                                    }
                                }
                                
                                HStack(alignment: .top, spacing: groupBoxSpacing) {
                                    iOSBookViewGroupBox(title: "Categories", icon: "folder", width: groupBoxWidth) {
                                        if book.categories != nil && book.sortedCategories.count > 0 {
                                            WrappingSmallChipsWithName<Category>(data: book.sortedCategories, chipColor: CATEGORY_COLOR, alignment: .leading)
                                        }
                                        else {
                                            Text("No categories selected")
                                        }
                                    }
                                    
                                    iOSBookViewGroupBox(title: "Tags", icon: "tag", width: groupBoxWidth) {
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
                            }
                            
                            Group {
                                iOSBookViewGroupBox(title: "Translators", icon: "person.2") {
                                    if book.translators != nil && book.sortedTranslators.count > 0 {
                                        WrappingSmallChipsWithName<Translator>(data: book.sortedTranslators, chipColor: TRANSLATOR_COLOR, alignment: .leading)
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
        .toolbar {
            ToolbarItem {
                Button(action: { showEditBookSheet.toggle() }) {
                    Label("Edit", systemImage: "pencil")
                }
            }
            ToolbarItem {
                Button(action: deleteBooks) {
                    Label("Delete", systemImage: "trash")
                }
            }
        }
        .sheet(isPresented: $showEditBookSheet) {
            iOSEditBookSheet(book: book)
        }
    }
    
    private func deleteBooks() {
        // TODO
    }
}

struct iPadOSBookView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let book = context.registeredObjects.first(where: { $0 is Book }) as! Book
        
        iPadOSBookView(book: book).preferredColorScheme(.dark).environment(\.managedObjectContext, context)
    }
}
