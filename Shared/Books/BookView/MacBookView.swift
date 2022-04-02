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
                
                ScrollView {
                    ZStack {
                        BookViewBookCoverBlur(bookcover: bookcover)
                        
                        VStack(spacing: 30) {
                            VStack(spacing: 10) {
                                BookViewBookCoverTitle(bookcover: bookcover, title: unwrappedBook.title!)
                                BookViewAuthors(authors: unwrappedBook.sortedAuthors)
                            }
                            
                            HStack(spacing: 50) {
                                BookViewTextWithLabel(label: "Reading Status", text: unwrappedBook.readingStatusString ?? "")
                                BookViewTextWithLabel(label: "Date Started", text: unwrappedBook.dateStartedFormatted)
                                BookViewTextWithLabel(label: "Date Finished", text: unwrappedBook.dateFinishedFormatted)
                                BookViewTextWithLabel(label: "Page Count", text: unwrappedBook.pageCount > 0 ? String(unwrappedBook.pageCount) : "")
                            }
                            
                            HStack(spacing: 50) {
                                BookViewTextWithLabel(label: "Publisher", text: unwrappedBook.publisher?.name ?? "")
                                BookViewTextWithLabel(label: "Book Format", text: unwrappedBook.bookFormatStrings[0])
                            }
                            
                            HStack(alignment: .top, spacing: 30) {
                                MacBookViewGroupBox(title: "Editors", icon: "person.2.wave.2") {
                                    if unwrappedBook.editors != nil && unwrappedBook.sortedEditors.count > 0 {
                                        WrappingSmallChipsWithName<Editor>(data: unwrappedBook.sortedEditors, chipColor: EDITOR_COLOR, alignment: .leading)
                                    }
                                    else {
                                        Text("No editors selected")
                                    }
                                }
                                
                                MacBookViewGroupBox(title: "Genres", icon: "text.book.closed") {
                                    if unwrappedBook.genres != nil && unwrappedBook.sortedGenres.count > 0 {
                                        WrappingSmallChipsWithName<Genre>(data: unwrappedBook.sortedGenres, chipColor: GENRE_COLOR, alignment: .leading)
                                    }
                                    else {
                                        Text("No genres selected")
                                    }
                                }
                            }
                            
                            HStack(alignment: .top, spacing: 20) {
                                MacBookViewGroupBox(title: "Categories", icon: "folder") {
                                    if unwrappedBook.categories != nil && unwrappedBook.sortedCategories.count > 0 {
                                        WrappingSmallChipsWithName<Category>(data: unwrappedBook.sortedCategories, chipColor: CATEGORY_COLOR, alignment: .leading)
                                    }
                                    else {
                                        Text("No categories selected")
                                    }
                                }
                                
                                MacBookViewGroupBox(title: "Tags", icon: "tag") {
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
                        }
                        .offset(y: offset)
                        .frame(maxWidth: 800.0)
                        .padding()
                        .padding(.bottom, offset)
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
            MacBookView(book: book).preferredColorScheme(.dark).padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/).frame(height: 1200).environment(\.managedObjectContext, context)
//            MacBookView(book: book).preferredColorScheme(.light).padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/).frame(height: 1200.0).environment(\.managedObjectContext, context)
        }
    }
}
