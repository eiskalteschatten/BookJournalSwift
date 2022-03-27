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
            languages = await getAllLanguages()
        }
    }
}

struct LanguagePicker_Previews: PreviewProvider {
    @State static var selection = ""
    
    static var previews: some View {
        LanguagePicker(selection: $selection)
    }
}
