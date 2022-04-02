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
                                if let status = unwrappedBook.readingStatus {
                                    if let statusKey = BookReadingStatus(rawValue: status) {
                                        BookViewTextWithLabel(label: "Reading Status", text: bookReadingStatusProperties[statusKey]!)
                                    }
                                }
                                
                                if unwrappedBook.dateStarted != nil {
                                    BookViewTextWithLabel(label: "Date Started", text: unwrappedBook.dateStartedFormatted)
                                }
                                
                                if unwrappedBook.dateFinished != nil {
                                    BookViewTextWithLabel(label: "Date Finished", text: unwrappedBook.dateFinishedFormatted)
                                }
                            }
                            
                            HStack(spacing: 20) {
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
                            
                            MacBookViewGroupBox(title: "Editors", icon: "person.2.wave.2") {
                                if unwrappedBook.editors != nil && unwrappedBook.sortedEditors.count > 0 {
                                    let editors = unwrappedBook.sortedEditors.map{ $0.name ?? "" }.joined(separator: ", ")
                                    Text(editors)
                                }
                                else {
                                    Text("No editors selected")
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
