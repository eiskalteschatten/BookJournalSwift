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
    
    private struct NamedLanguage: Hashable {
        let name: String;
        let identifier: String;
    }
    
    @State private var sortedLanguages: [NamedLanguage] = []
    
    var body: some View {
        Group {
            if sortedLanguages.count == 0 {
                ProgressView()
            }
            else {
                Picker(title, selection: $selection) {
                    ForEach(sortedLanguages, id: \.self) { language in
                        Text(language.name)
                            .tag(language.identifier)
                    }
                }
            }
        }
        .task {
            await getSortedLanguages()
        }
    }
    
    private func getSortedLanguages() async {
        let identifiers = NSLocale.availableLocaleIdentifiers
        let locale = NSLocale(localeIdentifier: NSLocale.current.languageCode ?? "en_US")
        
        let languages = identifiers.map {
            NamedLanguage(name: locale.displayName(forKey: NSLocale.Key.identifier, value: $0)!, identifier: $0)
        }
        
        sortedLanguages = languages.sorted {
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
