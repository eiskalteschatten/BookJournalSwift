//
//  MacNewBookStep6.swift
//  BookJournal (macOS)
//
//  Created by Alex Seifert on 21.03.22.
//

import SwiftUI

struct MacNewBookStep6: View {
    @ObservedObject var bookModel: BookModel
    
    var body: some View {
        VStack {
            MacNewBookStepTitle("World")
            
            Form {
                // Country of Origin
                Text("Country of Origin")
        //        NavigationLink(
        //            destination: CountriesSearchList(selectedItem: $bookModel.countryOfOrigin),
        //            tag: Screen.addCountryOfOrigin,
        //            selection: $screen,
        //            label: { PickerMimickerWithName<Country>(title: "Country of Origin", data: bookModel.countryOfOrigin) }
        //        )

                // Translators
                Text("Translators")
        //        NavigationLink(
        //            destination: TranslatorsSearchList(selectedItems: $bookModel.translators),
        //            tag: Screen.addTranslators,
        //            selection: $screen,
        //            label: { WrappingSmallChipsWithName<Translator>(title: "Translators", data: bookModel.translators, chipColor: TRANSLATOR_COLOR) }
        //        )

//                LanguagePicker(title: "Original Language", selection: $bookModel.originalLanguage)
//                LanguagePicker(title: "Language Read In", selection: $bookModel.languageReadIn)
            }
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
