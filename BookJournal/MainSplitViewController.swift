//
//  MainSplitViewController.swift
//  BookJournal
//
//  Created by Alex Seifert on 02/04/2018.
//  Copyright © 2018 Alex Seifert. All rights reserved.
//

import Cocoa

class MainSplitViewController: NSSplitViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override var representedObject: Any? {
        didSet {
            /*print("in here")
            for viewController in self.childViewControllers {
                print("in here too")
                viewController.representedObject = representedObject
            }*/
        }
    }
}
