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
        if authors != nil {
            WrappingSmallChipsWithName<Author>(data: authors!, chipColor: AUTHOR_COLOR)
        }
    }
}

struct BookViewAuthors_Previews: PreviewProvider {
    static var previews: some View {
        BookViewAuthors()
    }
}
