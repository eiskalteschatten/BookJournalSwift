//
//  SidebarViewModel.swift
//  BookJournal
//
//  Created by Alex Seifert on 04.05.22.
//

import SwiftUI

class SidebarViewModel: ObservableObject {
    @Published var screen: String?
    @Published var showEditSheet = false
    @Published var listToEdit: ListOfBooks?
    
    #if os(iOS)
    @Published var presentDeleteAlert = false
    #endif
}
