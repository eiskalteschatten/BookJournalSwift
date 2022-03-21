//
//  MacNewBookStepTitle.swift
//  BookJournal (macOS)
//
//  Created by Alex Seifert on 21.03.22.
//

import SwiftUI

struct MacNewBookStepTitle: View {
    var title: String
    
    init(_ title: String) {
        self.title = title
    }
    
    var body: some View {
        Text(title)
            .font(.system(.title))
            .padding(.bottom, 35)
    }
}

struct MacNewBookStepTitle_Previews: PreviewProvider {
    static var previews: some View {
        MacNewBookStepTitle("Bookcover & Title")
    }
}
