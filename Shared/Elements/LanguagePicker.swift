//
//  LanguagePicker.swift
//  BookJournal
//
//  Created by Alex Seifert on 19.03.22.
//

import SwiftUI

struct LanguagePicker: View {
    var title: String = "Choose Language"
    @Binding var selection: String
    
    @State private var languages: [Language] = []
    
    var body: some View {
        Picker(title, selection: $selection) {
            ForEach(languages, id: \.self) { language in
                Text("\(language.name) (\(language.nativeName))")
                    .tag(language.code)
            }
        }
        .task {
            await getSortedLanguages()
        }
    }
    
    private func getSortedLanguages() async {
        let url = Bundle.main.url(forResource: "languages", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        let decoder = JSONDecoder()
        let decoded = try! decoder.decode(DecodedLanguageArray.self, from: data)
        let unsortedLanguages = decoded.array
        
        languages = unsortedLanguages.sorted {
            return $0.name < $1.name
        }
    }
}

struct LanguagePicker_Previews: PreviewProvider {
    @State static var selection = ""
    
    static var previews: some View {
        LanguagePicker(selection: $selection)
    }
}
