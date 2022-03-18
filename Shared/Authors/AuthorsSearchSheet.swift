//
//  AuthorsSearchSheet.swift
//  BookJournal
//
//  Created by Alex Seifert on 18.03.22.
//

import SwiftUI

struct AuthorsSearchSheet: View {
    @Binding var authors: [Author]
    
    // TODO: Replace with actual authors
    private let mockAuthors = ["Holly", "Josh", "Rhonda", "Ted"]
    
    var body: some View {
        SearchSheet<Author>(title: "Search Authors", data: mockAuthors, selectedData: $authors)
    }
}

struct AuthorsSearchSheet_Previews: PreviewProvider {
    @State static var authors: [Author] = []
    
    static var previews: some View {
        AuthorsSearchSheet(authors: $authors)
    }
}
