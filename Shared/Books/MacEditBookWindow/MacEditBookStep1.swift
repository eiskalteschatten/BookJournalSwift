//
//  MacEditBookStep1.swift
//  BookJournal (macOS)
//
//  Created by Alex Seifert on 21.03.22.
//

import SwiftUI
import os

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
                    showErrorAlert(
                        error: error as NSError,
                        errorMessage: "An error occurred while choosing a book cover image!",
                        subErrorMessage: "Please try again.",
                        logger: Logger(
                            subsystem: Bundle.main.bundleIdentifier!,
                            category: String(describing: MacEditBookStep1.self)
                        )
                    )
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
