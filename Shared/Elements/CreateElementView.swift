//
//  CreateElementView.swift
//  BookJournal
//
//  Created by Alex Seifert on 23.03.22.
//

import SwiftUI

struct CreateElementView<Content: View>: View {
    var title: String
    var close: () -> Void
    var save: () -> Void
    @ViewBuilder var content: Content
    
    var body: some View {
        VStack {
            #if os(macOS)
            Text(title)
                .font(.system(.title3))
            #endif
            
            content
            #if os(iOS)
            .navigationBarTitle(Text(title), displayMode: .inline)
                .navigationBarItems(
                    trailing: Button(action: {
                        save()
                        close()
                    }) {
                        Text("Save").bold()
                    }
                )
            #else
            .padding(.bottom)
            #endif
            
            #if os(macOS)
            HStack {
                Spacer()

                Button(action: close) {
                    Text("Cancel")
                }
                .keyboardShortcut(.cancelAction)
                
                Button(action: {
                    save()
                    close()
                }) {
                    Text("Save")
                }
                .keyboardShortcut(.defaultAction)
            }
            #endif
        }
        #if os(macOS)
        .frame(minWidth: 300)
        .padding()
        #endif
    }
}

struct CreateElementView_Previews: PreviewProvider {
    static var previews: some View {
        CreateElementView(title: "Create Something!", close: {}, save: {}) {
            Text("Test Element")
        }
    }
}
