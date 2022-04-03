//
//  iOSBookView.swift
//  BookJournal (iOS)
//
//  Created by Alex Seifert on 31.03.22.
//

import SwiftUI

struct iOSBookView: View {
    var book: Book?
    
    var body: some View {
        VStack {
            if let unwrappedBook = book {
                let bookcover = getBookcover(book: unwrappedBook)
                let offset = 100.0
                let textWithLabelSpacing = 50.0
                let groupBoxSpacing = 20.0
//                let groupBoxWidth = (maxWidth / 2) - (groupBoxSpacing / 2)
                
                GeometryReader { metrics in
                    ScrollView {
                        ZStack {
                            BookViewBookCoverBlur(bookcover: bookcover)
                        
                            VStack(spacing: 30) {
                                VStack(spacing: 10) {
                                    BookViewBookCoverTitle(bookcover: bookcover, title: unwrappedBook.title!)
                                    BookViewAuthors(authors: unwrappedBook.sortedAuthors)
                                }
                                
                                BookViewRating(rating: Int(unwrappedBook.rating))
                                
                                Spacer()
                                
                                Group {
                                    let width = metrics.size.width * 0.35
                                    
                                    HStack(spacing: textWithLabelSpacing) {
                                        BookViewTextWithLabel(label: "Page Count", text: unwrappedBook.pageCount > 0 ? String(unwrappedBook.pageCount) : "")
                                            .frame(width: width)
                                        BookViewTextWithLabel(label: "Reading Status", text: unwrappedBook.readingStatusString ?? "")
                                            .frame(width: width)
                                    }

                                    HStack(spacing: textWithLabelSpacing) {
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
                                    }
                                    
                                    HStack(spacing: textWithLabelSpacing) {
                                        BookViewTextWithLabel(label: "Year Published", text: unwrappedBook.yearPublished > 0 ? String(unwrappedBook.yearPublished) : "")
                                            .frame(width: width)
                                        BookViewTextWithLabel(label: "ISBN", text: unwrappedBook.isbn ?? "")
                                            .frame(width: width)
                                    }
                                }
                                
                                Spacer()
                                
                                if unwrappedBook.editors != nil && unwrappedBook.sortedEditors.count > 0 {
                                    iOSBookViewGroupBox(title: "Editors", icon: "person.2.wave.2") {
                                        VStack(alignment: .leading) {
                                            let editors = unwrappedBook.sortedEditors.map{ $0.name ?? "" }.joined(separator: ", ")
                                            Text(editors)
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                }
                            }
                        }
                        .offset(y: offset)
                        .padding()
                        .padding(.bottom, offset)
                    }
                }
                .edgesIgnoringSafeArea(.top)
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

struct iOSBookView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let book = context.registeredObjects.first(where: { $0 is Book }) as! Book
        
        Group {
            iOSBookView(book: book).preferredColorScheme(.dark).environment(\.managedObjectContext, context)
//            iOSBookView(book: book).preferredColorScheme(.light).environment(\.managedObjectContext, context)
        }
    }
}

