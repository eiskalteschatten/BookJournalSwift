//
//  MacNewBookStep4.swift
//  BookJournal (macOS)
//
//  Created by Alex Seifert on 21.03.22.
//

import SwiftUI

struct MacNewBookStep4: View {
    @ObservedObject var bookModel: BookModel
    
    @State private var showNewGenreSheet = false
    @State private var showNewCategorySheet = false
    @State private var showNewTagSheet = false
    
    var body: some View {
        VStack {
            MacNewBookStepTitle("Categorization")

            // Genres
            VStack(alignment: .leading) {
                HStack {
                    Text("Genres")
                    Spacer()
                    Button(action: {
                        showNewGenreSheet.toggle()
                    }, label: {
                        Text("New Genre")
                    })
                }
                
                GenresSearchList(selectedItems: $bookModel.genres)
            }
            .sheet(isPresented: $showNewGenreSheet) {
                CreateGenre(showScreen: $showNewGenreSheet)
            }
            
            Divider()
                .padding(.vertical)
        
            // Categories
            VStack(alignment: .leading) {
                HStack {
                    Text("Categories")
                    Spacer()
                    Button(action: {
                        showNewCategorySheet.toggle()
                    }, label: {
                        Text("New Category")
                    })
                }
                
                CategoriesSearchList(selectedItems: $bookModel.categories)
            }
            .sheet(isPresented: $showNewCategorySheet) {
                CreateCategory(showScreen: $showNewCategorySheet)
            }
            
            Divider()
                .padding(.vertical)
        
            // Tags
            VStack(alignment: .leading) {
                HStack {
                    Text("Tags")
                    Spacer()
                    Button(action: {
                        showNewTagSheet.toggle()
                    }, label: {
                        Text("New Tag")
                    })
                }
                
                TagsSearchList(selectedItems: $bookModel.tags)
            }
            .sheet(isPresented: $showNewTagSheet) {
                CreateTag(showScreen: $showNewTagSheet)
            }
        }
    }
}

struct MacNewBookStep4_Previews: PreviewProvider {
    @StateObject static var bookModel = BookModel()
    
    static var previews: some View {
        MacNewBookStep4(bookModel: bookModel)
            .frame(height: 500.0)
    }
}
