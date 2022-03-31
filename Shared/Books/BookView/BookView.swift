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
                let bookcover = getBookcover(book: book!)
                let offset = 100.0
                
                ScrollView {
                    ZStack {
                        GeometryReader { geometry in
                            if geometry.frame(in: .global).minY <= 0 {
                                bookcover
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: geometry.size.width, height: geometry.size.height)
                                    .offset(y: geometry.frame(in: .global).minY / 9)
                                    .clipped()
                                    .blur(radius: 30)
                                    .opacity(0.4)
                            }
                            else {
                                bookcover
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: geometry.size.width, height: geometry.size.height + geometry.frame(in: .global).minY)
                                    .clipped()
                                    .offset(y: -geometry.frame(in: .global).minY)
                                    .blur(radius: 30)
                                    .opacity(0.4)
                            }
                        }
                        .frame(height: 200)
                        
                        VStack(spacing: 30) {
                            VStack(spacing: 30) {
                                #if os(macOS)
                                let frameHeight = 400.0
                                #else
                                let frameHeight = 307.0
                                #endif
                                
                                bookcover
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: frameHeight)
                                    .padding(.horizontal)
                                    .shadow(radius: 5)
                                
                                Text(book!.title!)
                                    .font(.title)
                            }
                            
                            BookViewAuthors(authors: book!.sortedAuthors)
                        }
                        .offset(y: offset)
                        .frame(maxWidth: 800.0)
                        .padding()
                        .padding(.bottom, offset)
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
        Group {
            BookView(book: book).preferredColorScheme(.dark).padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/).frame(height: /*@START_MENU_TOKEN@*/800.0/*@END_MENU_TOKEN@*/).environment(\.managedObjectContext, context)
            BookView(book: book).preferredColorScheme(.light).padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/).frame(height: 800.0).environment(\.managedObjectContext, context)
        }
    }
}
