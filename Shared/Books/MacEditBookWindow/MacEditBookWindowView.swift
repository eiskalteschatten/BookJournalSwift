//
//  MacEditBookWindowView.swift
//  BookJournal (macOS)
//
//  Created by Alex Seifert on 25.02.22.
//

import SwiftUI

struct MacEditBookWindowView: View {
    var newBookWindow: MacEditBookWindowManager?
    
    private enum Screen: Int, CaseIterable {
        case step1, step2, step3, step4, step5, step6, step7, step8
    }
    
    @State private var screen: Screen = .step1
    @ObservedObject private var bookModel: BookModel
    
    private let lastStep: Screen = .step8
    
    init(newBookWindow: MacEditBookWindowManager? = nil, book: Book? = nil) {
        self.newBookWindow = newBookWindow
        bookModel = BookModel(book: book)
    }
    
    var body: some View {
        VStack {
            Group {
                switch screen {
                case .step1:
                    MacEditBookStep1(bookModel: bookModel)
                case .step2:
                    MacEditBookStep2(bookModel: bookModel)
                case .step3:
                    MacEditBookStep3(bookModel: bookModel)
                case .step4:
                    MacEditBookStep4(bookModel: bookModel)
                case .step5:
                    MacEditBookStep5(bookModel: bookModel)
                case .step6:
                    MacEditBookStep6(bookModel: bookModel)
                case .step7:
                    MacEditBookStep7(bookModel: bookModel)
                case .step8:
                    MacEditBookStep8(bookModel: bookModel)
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
                    newBookWindow?.close()
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
                        bookModel.save()
                        newBookWindow?.close(closeWithPrompt: false)
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

struct MacEditBookWindowView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        Group {
            MacEditBookWindowView().preferredColorScheme(.dark).environment(\.managedObjectContext, context)
        }
    }
}
