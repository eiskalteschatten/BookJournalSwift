//
//  GlobalViewModel.swift
//  BookJournal
//
//  Created by Alex Seifert on 29.04.22.
//

import SwiftUI

final class GlobalViewModel: ObservableObject {
    @Published var selectedBook: Book?
}
