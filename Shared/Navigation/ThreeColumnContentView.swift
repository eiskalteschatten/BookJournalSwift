//
//  ThreeColumnContentView.swift
//  BookJournal
//
//  Created by Alex Seifert on 04.04.22.
//

import SwiftUI

struct ThreeColumnContentView: View {
    var body: some View {
        NavigationView {
            Sidebar()
            
            EmptyView()
            
            #if os(macOS)
            MacBookViewWrapper()
            #else
            iOSBookViewWrapper()
            #endif
        }
    }
}

#if os(iOS)
extension UISplitViewController {
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.show(.primary)
    }
}
#endif

struct ThreeColumnContentView_Previews: PreviewProvider {
    static var previews: some View {
        ThreeColumnContentView()
    }
}
