//
//  BookViewTextWithLabel.swift
//  BookJournal
//
//  Created by Alex Seifert on 02.04.22.
//

import SwiftUI

struct BookViewTextWithLabel: View {
    let label: String
    let text: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .font(.system(.footnote))
                .textCase(.uppercase)
                .opacity(0.7)
            
            Text(text)
        }
    }
}

struct BookViewTextWithLabel_Previews: PreviewProvider {
    static var previews: some View {
        BookViewTextWithLabel(label: "Label", text: "I'm a bit of text")
    }
}
