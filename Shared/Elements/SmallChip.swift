//
//  SmallChip.swift
//  BookJournal
//
//  Created by Alex Seifert on 26.02.22.
//

import SwiftUI

struct SmallChip<Content: View>: View {
    var action: () -> Void
    var background: Color = .yellow
    var foregroundColor: Color = .black
    @ViewBuilder var content: Content
    
    var body: some View {
        Button(action: action, label: {
            content
                .padding(.vertical, 5)
                .padding(.horizontal, 10)
                .font(.system(size: 13))
        })
            .foregroundColor(foregroundColor)
            .background(background)
            .cornerRadius(15)
    }
}

struct SmallChip_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            SmallChip(action: {}) {
                Text("Text SmallChip")
            }
            SmallChip(action: {}) {
                Label("Image SmallChip", systemImage: "desktopcomputer")
            }
            SmallChip(action: {}, background: .blue, foregroundColor: .white) {
                Label("Blue Image SmallChip", systemImage: "macwindow")
            }
        }
    }
}
