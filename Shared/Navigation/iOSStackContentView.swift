//
//  iOSStackContentView.swift
//  BookJournal (iOS)
//
//  Created by Alex Seifert on 02.05.22.
//

import SwiftUI

struct iOSStackContentView: View {
    var body: some View {
        NavigationView {
            Sidebar()
        }
    }
}

struct iOSStackContentView_Previews: PreviewProvider {
    static var previews: some View {
        iOSStackContentView()
    }
}
