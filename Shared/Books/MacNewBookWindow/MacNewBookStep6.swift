//
//  MacNewBookStep6.swift
//  BookJournal (macOS)
//
//  Created by Alex Seifert on 21.03.22.
//

import SwiftUI

struct MacNewBookStep6: View {
    @ObservedObject var bookModel: BookModel
    
    @State private var showNewCountrySheet = false
    
    var body: some View {
        VStack {
            MacNewBookStepTitle("World")
            
            // Country of Origin
            CountriesSearchList(title: "Country of Origin", selectedItem: $bookModel.countryOfOrigin)
            
            Divider()
                .padding(.vertical)
            
            // Translators
            TranslatorsSearchList(selectedItems: $bookModel.translators)

//                LanguagePicker(title: "Original Language", selection: $bookModel.originalLanguage)
//                LanguagePicker(title: "Language Read In", selection: $bookModel.languageReadIn)
        }
    }
}

struct MacNewBookStep6_Previews: PreviewProvider {
    @StateObject static var bookModel = BookModel()
    
    static var previews: some View {
        MacNewBookStep6(bookModel: bookModel)
            .frame(height: 500.0)
    }
}
