//
//  MacEditBookStep7.swift
//  BookJournal (macOS)
//
//  Created by Alex Seifert on 27.03.22.
//

import SwiftUI

struct MacEditBookStep7: View {
    @ObservedObject var bookModel: BookModel
    
    var body: some View {
        VStack {
            MacEditBookStepTitle("World")
            
            // Country of Origin
            CountriesSearchList(title: "Country Of Origin", selectedItem: $bookModel.countryOfOrigin)
            
            Divider()
                .padding(.vertical)
            
            // Translators
            TranslatorsSearchList(selectedItems: $bookModel.translators)
            
            Divider()
                .padding(.vertical)

            Form {
                LanguagePicker(title: "Original Language:", selection: $bookModel.originalLanguage)
                LanguagePicker(title: "Language Read In:", selection: $bookModel.languageReadIn)
            }
        }
    }
}

struct MacEditBookStep7_Previews: PreviewProvider {
    @StateObject static var bookModel = BookModel()
    
    static var previews: some View {
        MacEditBookStep7(bookModel: bookModel)
            .frame(height: 500.0)
    }
}
