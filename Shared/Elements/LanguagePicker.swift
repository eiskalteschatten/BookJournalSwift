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
    
    var body: some View {
        let identifiers = NSLocale.availableLocaleIdentifiers
        let locale = NSLocale(localeIdentifier: NSLocale.current.languageCode ?? "en_US")
        
        Picker(title, selection: $selection) {
            ForEach(identifiers, id: \.self) { identifier in
                let name = locale.displayName(forKey: NSLocale.Key.identifier, value: identifier)!
                Text(name)
                    .tag(identifier)
            }
        }
    }
}

struct LanguagePicker_Previews: PreviewProvider {
    @State static var selection = ""
    
    static var previews: some View {
        LanguagePicker(selection: $selection)
    }
}
