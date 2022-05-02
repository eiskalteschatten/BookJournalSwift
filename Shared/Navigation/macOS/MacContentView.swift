//
//  MacContentView.swift
//  BookJournal (macOS)
//
//  Created by Alex Seifert on 04.04.22.
//

import SwiftUI

struct MacContentView: View {
    var body: some View {
        NavigationView {
            Sidebar()
            EmptyView()
            MacBookViewWrapper()
        }
    }
}

struct MacContentView_Previews: PreviewProvider {
    static var previews: some View {
        MacContentView()
    }
}
