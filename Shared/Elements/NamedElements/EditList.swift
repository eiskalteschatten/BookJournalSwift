//
//  EditList.swift
//  BookJournal
//
//  Created by Alex Seifert on 04.05.22.
//

import SwiftUI

struct EditList: View {
    @Binding var screen: SearchListNamedElementScreen?
    @Binding var showScreen: Bool
    
    @ObservedObject private var editListViewModel: EditListViewModel
    
    // Navigvation View
    init(screen: Binding<SearchListNamedElementScreen?>, list: ListOfBooks? = nil) {
        self._screen = screen
        self._showScreen = Binding.constant(false)
        self.editListViewModel = EditListViewModel(list: list)
    }
    
    // Screen View
    init(showScreen: Binding<Bool>, list: ListOfBooks? = nil) {
        self._screen = Binding.constant(nil)
        self._showScreen = showScreen
        self.editListViewModel = EditListViewModel(list: list)
    }

    var body: some View {
        #if os(iOS)
        if screen == nil {
            NavigationView {
                InternalCreateElementView(screen: $screen, showScreen: $showScreen, editListViewModel: editListViewModel)
            }
        }
        else {
            InternalCreateElementView(screen: $screen, showScreen: $showScreen, editListViewModel: editListViewModel)
        }
        #else
        InternalCreateElementView(screen: $screen, showScreen: $showScreen, editListViewModel: editListViewModel)
        #endif
    }
}

fileprivate struct InternalCreateElementView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding var screen: SearchListNamedElementScreen?
    @Binding var showScreen: Bool
    @ObservedObject var editListViewModel: EditListViewModel
    
    var body: some View {
        CreateElementView(
            title: editListViewModel.isEditing ? "Edit List" : "Create a List",
            close: close,
            save: editListViewModel.save
        ) {
            Form {
                TextField(
                    "Name",
                    text: $editListViewModel.name
                )
                
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5)) {
                        ForEach(listSFSymbols, id: \.self) { symbol in
                            Image(systemName: symbol)
                                .padding(10)
                                .font(.system(size: 20))
                                .background {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(symbol == editListViewModel.icon ? Color.accentColor : Color.clear)
                                        .aspectRatio(1.0, contentMode: .fit)
                                }
                                .foregroundColor(symbol == editListViewModel.icon ? Color.black : Color.primary)
                                .onTapGesture {
                                    editListViewModel.icon = symbol
                                }
                        }
                    }
                }
                .padding(.top)
                .frame(maxHeight: 400)
            }
        }
        #if os(iOS)
        .if(screen == nil) { view in
            view.navigationBarItems(
                leading: Button(action: {
                    close()
                }) {
                    Text("Cancel")
                }
            )
        }
        #endif
    }
    
    private func close() {
        if screen != nil {
            screen = .home
        }
        
        if showScreen {
            showScreen.toggle()
        }
    }
}

struct EditList_Previews: PreviewProvider {
    static let viewContext = PersistenceController.preview.container.viewContext
    
    @State static var screen: SearchListNamedElementScreen?
    @State static var showScreen = true
    
    static var previews: some View {
        EditList(screen: $screen)
        EditList(showScreen: $showScreen)
    }
}
