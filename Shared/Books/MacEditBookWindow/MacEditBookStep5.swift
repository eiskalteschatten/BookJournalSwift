//
//  MacEditBookStep5.swift
//  BookJournal (macOS)
//
//  Created by Alex Seifert on 21.03.22.
//

import SwiftUI

struct MacEditBookStep5: View {
    @ObservedObject var bookModel: BookModel
    
    var body: some View {
        VStack {
            MacEditBookStepTitle("Lists")
            
            // Lists
            SearchListLists(selectedData: $bookModel.lists)
        }
    }
}

struct MacEditBookStep5_Previews: PreviewProvider {
    @StateObject static var bookModel = BookModel()
    
    static var previews: some View {
        MacEditBookStep5(bookModel: bookModel)
            .frame(height: 500.0)
    }
}
