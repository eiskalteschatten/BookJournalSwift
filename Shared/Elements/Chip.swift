//
//  Chip.swift
//  BookJournal
//
//  Created by Alex Seifert on 26.02.22.
//

import SwiftUI

struct Chip<Content: View>: View {
    var action: () -> Void
    var background: Color = .yellow
    var foregroundColor: Color = .black
    @ViewBuilder var content: Content
    
    var body: some View {
        Button(action: action, label: {
            content
                .padding(.vertical, 10)
                .padding(.horizontal, 15)
        })
            .foregroundColor(foregroundColor)
            .background(background)
            .cornerRadius(15)
    }
}

struct Chip_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Chip(action: {}) {
                Text("Text Chip")
            }
            Chip(action: {}) {
                Label("Image Chip", systemImage: "desktopcomputer")
            }
            Chip(action: {}, background: .blue, foregroundColor: .white) {
                Label("Blue Image Chip", systemImage: "macwindow")
            }
        }
    }
}
