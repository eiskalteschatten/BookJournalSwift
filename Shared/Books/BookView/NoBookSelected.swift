//
//  NoBookSelected.swift
//  BookJournal
//
//  Created by Alex Seifert on 27.04.22.
//

import SwiftUI

struct NoBookSelected: View {
    var body: some View {
        // TODO: show a monochrome version of the app icon
        Image(systemName: "book")
            .font(.system(size: 200))
            .opacity(0.1)
    }
}

struct NoBookSelected_Previews: PreviewProvider {
    static var previews: some View {
        NoBookSelected()
    }
}
