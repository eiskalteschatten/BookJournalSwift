//
//  MacNewBookStep7.swift
//  BookJournal (macOS)
//
//  Created by Alex Seifert on 27.03.22.
//

import SwiftUI

struct MacNewBookStep7: View {
    @ObservedObject var bookModel: BookModel
    
    #if os(macOS)
    private let originalLanguageTitle = "Original Language:"
    private let languageReadInTitle = "Language Read In:"
    #else
    private let originalLanguageTitle = "Original Language"
    private let languageReadInTitle = "Language Read In"
    #endif
    
    var body: some View {
        VStack {
            MacNewBookStepTitle("World")
            
            // Country of Origin
            CountriesSearchList(title: "Country Of Origin", selectedItem: $bookModel.countryOfOrigin)
            
            Divider()
                .padding(.vertical)
            
            // Translators
            TranslatorsSearchList(selectedItems: $bookModel.translators)
            
            Divider()
                .padding(.vertical)

            LanguagePicker(title: originalLanguageTitle, selection: $bookModel.originalLanguage)
            LanguagePicker(title: languageReadInTitle, selection: $bookModel.languageReadIn)
        }
    }
}

struct MacNewBookStep7_Previews: PreviewProvider {
    @StateObject static var bookModel = BookModel()
    
    static var previews: some View {
        MacNewBookStep7(bookModel: bookModel)
            .frame(height: 500.0)
    }
}
