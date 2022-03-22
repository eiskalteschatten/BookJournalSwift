//
//  MacNewBookWindowView.swift
//  BookJournal (macOS)
//
//  Created by Alex Seifert on 25.02.22.
//

import SwiftUI

struct MacNewBookWindowView: View {
    private enum Screen: Int, CaseIterable {
        case step1, step2, step3, step4, step5, step6
    }
    
    @State private var screen: Screen = .step1
    @StateObject private var bookModel = BookModel()
    
    private let lastStep: Screen = .step6
    
    var body: some View {
        VStack {
            Group {
                switch screen {
                case .step1:
                    MacNewBookStep1(bookModel: bookModel)
                case .step2:
                    MacNewBookStep2(bookModel: bookModel)
                case .step3:
                    MacNewBookStep3(bookModel: bookModel)
                case .step4:
                    MacNewBookStep4(bookModel: bookModel)
                case .step5:
                    MacNewBookStep5(bookModel: bookModel)
                case .step6:
                    MacNewBookStep6(bookModel: bookModel)
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
            
            HStack {
                ForEach(Screen.allCases, id: \.self) { step in
                    let opacity = screen.rawValue == step.rawValue ? 1.0 : 0.3
                    Button(action: {
                        screen = step
                    }, label: {
                        Image(systemName: "circle.fill")
                            .font(.system(size: 7))
                            .opacity(opacity)
                    })
                    .buttonStyle(.plain)
                }
            }
            .padding(.vertical)
            
            HStack {
                Button("Cancel", action: {
                    NSApplication.shared.keyWindow?.close()
                })
                .keyboardShortcut(.cancelAction)
                
                Spacer()
                
                if screen != .step1 {
                    Button("Previous", action: goToPrevStep)
                }
                
                if screen != lastStep {
                    Button("Next", action: goToNextStep)
                    .keyboardShortcut(.defaultAction)
                }
                else {
                    Button("Finish", action: {
                        bookModel.saveBook()
                        NSApplication.shared.keyWindow?.close()
                    })
                    .keyboardShortcut(.defaultAction)
                }
            }
        }
        .padding()
        .frame(minWidth: 450, minHeight: 500)
    }
    
    private func goToPrevStep() {
        if screen.rawValue > 0 {
            screen = Screen.allCases[screen.rawValue - 1]
        }
    }
    
    private func goToNextStep() {
        if screen.rawValue < lastStep.rawValue {
            screen = Screen.allCases[screen.rawValue + 1]
        }
    }
}

struct MacNewBookWindowView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        Group {
            MacNewBookWindowView().preferredColorScheme(.dark).environment(\.managedObjectContext, context)
        }
    }
}
