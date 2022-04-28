//
//  BookLinksView.swift
//  BookJournal
//
//  Created by Alex Seifert on 28.04.22.
//

import SwiftUI

struct BookLinksView: View {
    var body: some View {
        HStack(spacing: 20) {
            Button("Amazon", action: {})
                #if os(macOS)
                .buttonStyle(.link)
                #endif
            
            Button("Google Books", action: {})
                #if os(macOS)
                .buttonStyle(.link)
                #endif
        }
    }
}

struct BookLinksView_Previews: PreviewProvider {
    static var previews: some View {
        BookLinksView()
    }
}
