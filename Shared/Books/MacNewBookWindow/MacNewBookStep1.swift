//
//  MacNewBookStep1.swift
//  BookJournal (macOS)
//
//  Created by Alex Seifert on 21.03.22.
//

import SwiftUI

struct MacNewBookStep1: View {
    @ObservedObject var bookModel: BookModel
    
    var body: some View {
        VStack {
            MacNewBookStepTitle("Bookcover & Title")
            
            // Bookcover
            Image(systemName: "plus.square.dashed")
                .font(.system(size: 150))
                .foregroundColor(.accentColor)
            
            Button {
                // TODO: add function
            } label: {
                Text("Choose Image")
            }
            
            Button {
                // TODO: add function
            } label: {
                Text("Scan Image")
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
}

struct MacNewBookStep1_Previews: PreviewProvider {
    @StateObject static var bookModel = BookModel()
    
    static var previews: some View {
        MacNewBookStep1(bookModel: bookModel)
    }
}
