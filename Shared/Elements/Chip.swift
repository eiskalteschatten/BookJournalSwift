//
//  Chip.swift
//  BookJournal
//
//  Created by Alex Seifert on 26.02.22.
//

import SwiftUI

struct Chip<Content: View>: View {
    var background: Color = .yellow
    var foregroundColor: Color = .black
    @ViewBuilder var content: Content
    
    var body: some View {
        content
            .padding(.vertical, 10)
            .padding(.horizontal, 15)
            .background(
                Capsule()
                    .fill(background)
            )
            .foregroundColor(foregroundColor)
    }
}

struct Chip_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Chip {
                Text("Text Chip")
            }
            Chip {
                Label("Image Chip", systemImage: "desktopcomputer")
            }
            Chip(background: .blue, foregroundColor: .white) {
                Label("Blue Image Chip", systemImage: "macwindow")
            }
        }
    }
}
