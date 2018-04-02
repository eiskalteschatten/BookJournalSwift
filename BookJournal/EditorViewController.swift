//
//  EditorViewController.swift
//  BookJournal
//
//  Created by Alex Seifert on 02/04/2018.
//  Copyright © 2018 Alex Seifert. All rights reserved.
//

import Cocoa

class EditorViewController: NSViewController {
    @IBOutlet var commentsTextView: NSTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    @IBAction func toggleEditorToolbar(_ sender: NSMenuItem) {
        commentsTextView.usesInspectorBar = commentsTextView.usesInspectorBar ? false : true
        sender.state = commentsTextView.usesInspectorBar ? NSControl.StateValue.on : NSControl.StateValue.off
    }
    
}
