//
//  MacEditBookStep1.swift
//  BookJournal (macOS)
//
//  Created by Alex Seifert on 21.03.22.
//

import SwiftUI

struct MacEditBookStep1: View {
    @ObservedObject var bookModel: BookModel
    
    var body: some View {
        VStack {
            MacEditBookStepTitle("Book Cover & Title")
            
            // Bookcover
            Button(action: chooseBookcoverImage) {
                if let bookcover = bookModel.bookcover {
                    let image = NSImage(data: bookcover)
                    Image(nsImage: image!)
                        .resizable()
                        .scaledToFit()
                }
                else {
                    Image(systemName: "plus.square.dashed")
                        .font(.system(size: 150))
                        .foregroundColor(.accentColor)
                }
            }
            .buttonStyle(.plain)
            .frame(maxHeight: 250)
            .padding(.bottom)
            
            Button(action: chooseBookcoverImage) {
                Text("Choose Image")
            }
            
            // Title
            TextField(
                "Enter Title...",
                text: $bookModel.title
            )
            .textFieldStyle(PlainTextFieldStyle())
            .font(.system(size: 20, weight: .bold))
            .multilineTextAlignment(.center)
            .padding(.top, 35)
        }
    }
    
    private func chooseBookcoverImage() {
        let panel = NSOpenPanel()
        panel.prompt = "Choose Image"
        panel.worksWhenModal = true
        panel.canChooseDirectories = false
        panel.canChooseFiles = true
        panel.allowedContentTypes = [.image]
        panel.allowsMultipleSelection = false
        
        if panel.runModal() == .OK {
            if panel.url != nil {
                do {
                    try bookModel.bookcover = Data(contentsOf: panel.url!)
                } catch {
                    // TODO: Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nsError = error as NSError
                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }
            }
        }
    }
}

struct MacEditBookStep1_Previews: PreviewProvider {
    @StateObject static var bookModel = BookModel()
    
    static var previews: some View {
        MacEditBookStep1(bookModel: bookModel)
    }
}
