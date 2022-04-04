//
//  ContentView.swift
//  Shared
//
//  Created by Alex Seifert on 23.01.22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        #if os(macOS)
        MacContentView()
        #else
        iOSContentView()
        #endif
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
