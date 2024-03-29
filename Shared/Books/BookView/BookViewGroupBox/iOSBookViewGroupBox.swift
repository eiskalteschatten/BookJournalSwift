//
//  iOSBookViewGroupBox.swift
//  BookJournal (iOS)
//
//  Created by Alex Seifert on 02.04.22.
//

import SwiftUI

struct iOSBookViewGroupBox<Content: View>: View {
    var title: String
    var icon: String
    var width: CGFloat?
    @ViewBuilder var content: Content
    
    var body: some View {
        GroupBox(label:
            Label(title, systemImage: icon)
                .padding(.bottom, 3)
        ) {
            content
        }
        .frame(width: width)
    }
}

struct iOSBookViewGroupBox_Previews: PreviewProvider {
    static var previews: some View {
        iOSBookViewGroupBox(title: "Test Box", icon: "macpro.gen2") {
            Text("I'm content")
        }
    }
}
