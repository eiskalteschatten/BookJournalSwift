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
        if let unwrappedAuthors = authors {
            WrappingSmallChipsWithName<Author>(data: unwrappedAuthors, chipColor: AUTHOR_COLOR)
        }
    }
}

struct BookViewAuthors_Previews: PreviewProvider {
    static var previews: some View {
        BookViewAuthors()
    }
}
