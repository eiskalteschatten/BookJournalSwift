//
//  BookViewAuthors.swift
//  BookJournal
//
//  Created by Alex Seifert on 28.03.22.
//

import SwiftUI

struct BookViewAuthors: View {
    var authors: [Author]?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            if (authors != nil) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Authors")
                        .font(.title2)
                    
                    WrappingSmallChipsWithName<Author>(data: authors!, chipColor: AUTHOR_COLOR)
                }
            }
        }
    }
}

struct BookViewAuthors_Previews: PreviewProvider {
    static var previews: some View {
        BookViewAuthors()
    }
}
