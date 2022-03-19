//
//  Colors.swift
//  BookJournal
//
//  Created by Alex Seifert on 19.03.22.
//

import SwiftUI

func getArchivedColor(data: Data) -> Color {
    do {
        #if os(iOS)
        return try Color(NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data)!)
        #else
        return try Color(NSKeyedUnarchiver.unarchivedObject(ofClass: NSColor.self, from: data)!)
        #endif
    } catch {
        print(error)
    }

    return Color.clear
}
