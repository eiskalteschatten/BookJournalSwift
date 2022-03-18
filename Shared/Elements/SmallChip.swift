//
//  SmallChip.swift
//  BookJournal
//
//  Created by Alex Seifert on 26.02.22.
//

import SwiftUI

struct SmallChip<Content: View>: View {
    var background: Color = .accentColor
    var foregroundColor: Color = .black
    @ViewBuilder var content: Content
    
    var body: some View {
        content
            .padding(.vertical, 5)
            .padding(.horizontal, 10)
            .background(
                Capsule()
                    .fill(background)
            )
            .foregroundColor(foregroundColor)
            .font(.system(size: 13))
    }
}

struct SmallChip_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            SmallChip {
                Text("Text SmallChip")
            }
            SmallChip {
                Label("Image SmallChip", systemImage: "desktopcomputer")
            }
            SmallChip(background: .blue, foregroundColor: .white) {
                Label("Blue Image SmallChip", systemImage: "macwindow")
            }
        }
    }
}
