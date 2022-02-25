//
//  iOSTextFieldControl.swift
//  BookJournal
//
//  Created by Alex Seifert on 25.02.22.
//

import SwiftUI
import CoreData

struct iOSTextFieldControl: View {
    @Binding var value: String
    
    var label: String
    var labelIcon: String?
    var placeHolder: String
    var isNumberField: Bool? = false
    
    var body: some View {
        GroupBox(label:
            HStack {
                if labelIcon != nil {
                    Label(label, systemImage: labelIcon!)
                }
                else {
                    Text(label)
                }
            }
        ) {
            if isNumberField! == true {
                TextField(
                    placeHolder,
                    text: $value
                )
                    .keyboardType(.numberPad)
            }
            else {
                TextField(
                    placeHolder,
                    text: $value
                )
            }
        }.padding()
    }
}

struct iOSTextFieldControl_Previews: PreviewProvider {
    @State static var author: String = ""
    
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        Group {
            iOSTextFieldControl(value: $author, label: "A Text Field", labelIcon: "macpro.gen1.fill", placeHolder: "Enter something...")
                .preferredColorScheme(.dark)
                .padding(.all)
                .frame(height: /*@START_MENU_TOKEN@*/800.0/*@END_MENU_TOKEN@*/)
                .environment(\.managedObjectContext, context)
        }
    }
}


