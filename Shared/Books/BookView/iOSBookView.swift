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
            if book != nil {
                let bookcover = getBookcover(book: book!)
                let offset = 100.0
                
                ScrollView {
                    ZStack {
                        BookViewBookCoverBlur(bookcover: bookcover)
                        
                        VStack(spacing: 30) {
                            BookViewBookCoverTitle(bookcover: bookcover, title: book!.title!)
                            BookViewAuthors(authors: book!.sortedAuthors)
                            BookViewEditors(editors: book!.sortedEditors)
                        }
                        .offset(y: offset)
                        .frame(maxWidth: 800.0)
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
        let book = Book(context: context)
        Group {
            iOSBookView(book: book).preferredColorScheme(.dark).padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/).frame(height: /*@START_MENU_TOKEN@*/800.0/*@END_MENU_TOKEN@*/).environment(\.managedObjectContext, context)
            iOSBookView(book: book).preferredColorScheme(.light).padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/).frame(height: 800.0).environment(\.managedObjectContext, context)
        }
    }
}
