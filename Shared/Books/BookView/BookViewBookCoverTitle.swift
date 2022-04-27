//
//  BookViewBookCoverTitle.swift
//  BookJournal
//
//  Created by Alex Seifert on 31.03.22.
//

import SwiftUI

struct BookViewBookCoverTitle: View {
    var bookcover: Image
    var title: String?
    
    var body: some View {
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
            
            Text(title ?? "")
                .font(.title)
        }
    }
}

struct BookViewBookCoverTitle_Previews: PreviewProvider {
    static var previews: some View {
        BookViewBookCoverTitle(bookcover: Image(systemName: "macpro.gen1.fill"), title: "A Book")
    }
}
