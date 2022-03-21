//
//  MacNewBookStep3.swift
//  BookJournal (macOS)
//
//  Created by Alex Seifert on 21.03.22.
//

import SwiftUI

struct MacNewBookStep3: View {
    @ObservedObject var bookModel: BookModel
    
    var body: some View {
        Form {
            // Authors
            Text("Authors")
    //        NavigationLink(
    //            destination: AuthorsSearchList(selectedItems: $bookModel.authors),
    //            tag: Screen.addAuthors,
    //            selection: $screen,
    //            label: { WrappingSmallChipsWithName<Author>(title: "Authors", data: bookModel.authors, chipColor: AUTHOR_COLOR) }
    //        )
    //
            Text("Editors")
    //        // Editors
    //        NavigationLink(
    //            destination: EditorsSearchList(selectedItems: $bookModel.editors),
    //            tag: Screen.addEditors,
    //            selection: $screen,
    //            label: { WrappingSmallChipsWithName<Editor>(title: "Editors", data: bookModel.editors, chipColor: EDITOR_COLOR) }
    //        )
        }
    }
}

struct MacNewBookStep3_Previews: PreviewProvider {
    @StateObject static var bookModel = BookModel()
    
    static var previews: some View {
        MacNewBookStep3(bookModel: bookModel)
    }
}
