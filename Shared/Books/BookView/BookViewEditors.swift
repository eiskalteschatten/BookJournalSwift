//
//  BookViewEditors.swift
//  BookJournal
//
//  Created by Alex Seifert on 31.03.22.
//

import SwiftUI

struct BookViewEditors: View {
    var editors: [Editor]?
    
    var body: some View {
        GroupBox(label:
            Label("Editors", systemImage: "person.2.wave.2")
                .foregroundColor(.accentColor)
                .padding(.bottom, 3)
        ) {
            if editors != nil {
                VStack(alignment: .leading) {
                    ForEach(editors!) { editor in
                        if let name = editor.name {
                            Text(name)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

struct BookViewEditors_Previews: PreviewProvider {
    static var previews: some View {
        BookViewEditors()
    }
}
