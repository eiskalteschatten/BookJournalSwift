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
        VStack(alignment: .leading, spacing: 30) {
            if editors != nil && editors!.count > 0 {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Editors")
                        .font(.title2)
                    
                    WrappingSmallChipsWithName<Editor>(data: editors!, chipColor: EDITOR_COLOR, alignment: .leading)
                }
            }
        }
    }
}

struct BookViewEditors_Previews: PreviewProvider {
    static var previews: some View {
        BookViewEditors()
    }
}
