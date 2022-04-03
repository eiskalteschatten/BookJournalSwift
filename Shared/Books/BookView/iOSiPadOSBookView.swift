//
//  iOSiPadOSBookView.swift
//  BookJournal (iOS)
//
//  Created by Alex Seifert on 03.04.22.
//

import SwiftUI

struct iOSiPadOSBookView: View {
    var book: Book?
    
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    
    var body: some View {
        if horizontalSizeClass == .regular && verticalSizeClass == .regular {
            iPadOSBookView(book: book)
        }
        else {
            iOSBookView(book: book)
        }
    }
}

struct iOSiPadOSBookView_Previews: PreviewProvider {
    static var previews: some View {
        iOSiPadOSBookView()
    }
}
