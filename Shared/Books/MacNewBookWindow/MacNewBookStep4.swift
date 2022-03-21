//
//  MacNewBookStep4.swift
//  BookJournal (macOS)
//
//  Created by Alex Seifert on 21.03.22.
//

import SwiftUI

struct MacNewBookStep4: View {
    @ObservedObject var bookModel: BookModel
    
    var body: some View {
        Form {
            // Page Count
            TextField(
                "Page Count:",
                value: $bookModel.pageCount,
                format: .number
            )

            // Genres
            Text("Genres")
    //        NavigationLink(
    //            destination: GenresSearchList(selectedItems: $bookModel.genres),
    //            tag: Screen.addGenres,
    //            selection: $screen,
    //            label: { WrappingSmallChipsWithName<Genre>(title: "Genres", data: bookModel.genres, chipColor: GENRE_COLOR) }
    //        )
    //
            Text("Categories")
    //        // Categories
    //        NavigationLink(
    //            destination: CategoriesSearchList(selectedItems: $bookModel.categories),
    //            tag: Screen.addCategories,
    //            selection: $screen,
    //            label: { WrappingSmallChipsWithName<Category>(title: "Categories", data: bookModel.categories, chipColor: CATEGORY_COLOR) }
    //        )
    //
            Text("Tags")
    //        // Tags
    //        NavigationLink(
    //            destination: TagsSearchList(selectedItems: $bookModel.tags),
    //            tag: Screen.addTags,
    //            selection: $screen,
    //            label: { WrappingSmallChipsWithName<Tag>(title: "Tags", data: bookModel.tags, chipColor: TAG_COLOR) }
    //        )
        }
    }
}

struct MacNewBookStep4_Previews: PreviewProvider {
    @StateObject static var bookModel = BookModel()
    
    static var previews: some View {
        MacNewBookStep4(bookModel: bookModel)
    }
}
