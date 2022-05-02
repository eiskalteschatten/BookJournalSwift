//
//  ContentView.swift
//  Shared
//
//  Created by Alex Seifert on 23.01.22.
//

import SwiftUI

struct ContentView: View {
    #if os(iOS)
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    #endif
    
    var body: some View {
        #if os(macOS)
        ThreeColumnContentView()
        #else
        if horizontalSizeClass == .compact {
            iOSStackContentView()
        }
        else {
            ThreeColumnContentView()
        }
        #endif
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
