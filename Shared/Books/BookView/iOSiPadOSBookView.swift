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
        if let unwrappedBook = book {
            if horizontalSizeClass == .regular && verticalSizeClass == .regular {
                iPadOSBookView(book: unwrappedBook)
            }
            else {
                iOSBookView(book: unwrappedBook)
            }
        }
        else {
            // TODO: show monochrome logo
            Text("A monochrome logo should go here")
        }
    }
}

struct iOSiPadOSBookView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let book = context.registeredObjects.first(where: { $0 is Book }) as! Book
        iOSiPadOSBookView(book: book)
    }
}
