//
//  BookView.swift
//  BookJournal
//
//  Created by Alex Seifert on 20.02.22.
//

import SwiftUI
import CoreData

struct BookView: View {
    var book: Book?
    
    var body: some View {
        VStack {
            if book != nil {
                ScrollView {
                    GeometryReader { geometry in
                        if geometry.frame(in: .global).minY <= 0 {
                            Image("DefaultBookCover")
                                .resizable()
                                .scaledToFill()
                                .frame(width: geometry.size.width, height: geometry.size.height)
                                .offset(y: geometry.frame(in: .global).minY / 9)
                                .clipped()
                                .blur(radius: 30)
                                .opacity(0.4)
                        }
                        else {
                            Image("DefaultBookCover")
                                .resizable()
                                .scaledToFill()
                                .frame(width: geometry.size.width, height: geometry.size.height + geometry.frame(in: .global).minY)
                                .clipped()
                                .offset(y: -geometry.frame(in: .global).minY)
                                .blur(radius: 30)
                                .opacity(0.4)
                        }
                    }
                    .frame(height: 400)
                    
                    VStack(spacing: 30.0) {
                        // TODO: add actual cover image
                        Image("DefaultBookCover")
                            .resizable()
                            .frame(width: 200.0, height: 307.0)
                            .scaledToFit()
                        
                        Text(book!.title!)
                            .font(.title)
                        
                        if (book!.authors != nil) {
                            Text(getBookAuthors(book!.authors!))
                        }
                    }
                }
                #if os(iOS)
                .edgesIgnoringSafeArea(.top)
                #endif
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

struct BookView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let book = Book(context: context)
        BookView(book: book).padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/).environment(\.managedObjectContext, context)
    }
}
