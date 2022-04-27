//
//  MacEditBookStepTitle.swift
//  BookJournal (macOS)
//
//  Created by Alex Seifert on 21.03.22.
//

import SwiftUI

struct MacEditBookStepTitle: View {
    var title: String
    
    init(_ title: String) {
        self.title = title
    }
    
    var body: some View {
        Text(title)
            .font(.system(.title))
            .padding(.bottom)
    }
}

struct MacEditBookStepTitle_Previews: PreviewProvider {
    static var previews: some View {
        MacEditBookStepTitle("Book Cover & Title")
    }
}
