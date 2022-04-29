//
//  NoBookSelected.swift
//  BookJournal
//
//  Created by Alex Seifert on 27.04.22.
//

import SwiftUI

struct NoBookSelected: View {
    var body: some View {
        Image("MonochromeIcon")
            .resizable()
            .scaledToFit()
            .frame(maxWidth: 200)
            .opacity(0.1)
    }
}

struct NoBookSelected_Previews: PreviewProvider {
    static var previews: some View {
        NoBookSelected()
    }
}
