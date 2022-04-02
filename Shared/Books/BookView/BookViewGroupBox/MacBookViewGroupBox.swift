//
//  MacBookViewGroupBox.swift
//  BookJournal (macOS)
//
//  Created by Alex Seifert on 02.04.22.
//

import SwiftUI

struct MacBookViewGroupBox<Content: View>: View {
    var title: String
    var icon: String
    @ViewBuilder var content: Content
    
    var body: some View {
        VStack(alignment: .leading) {
            Label(title, systemImage: icon)
                .font(.system(.title3))
                .padding(.bottom, 3)

            content
        }
        .padding()
        .frame(minWidth: 350, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 10.0)
                .fill(.regularMaterial)
        )
    }
}

struct MacBookViewGroupBox_Previews: PreviewProvider {
    static var previews: some View {
        MacBookViewGroupBox(title: "Test Box", icon: "macpro.gen2") {
            Text("I'm content")
        }
    }
}
