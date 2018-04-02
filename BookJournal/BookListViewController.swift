//
//  ViewController.swift
//  BookJournal
//
//  Created by Alex Seifert on 01/04/2018.
//  Copyright © 2018 Alex Seifert. All rights reserved.
//

import Cocoa

class BookListViewController: NSViewController {
    let appDelegate = NSApplication.shared.delegate as! AppDelegate
    lazy var managedObjectContext: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /*if (self.representedObject == nil) {
            print ("test")
            //self.representedObject = self
        }
        
        print ("test2")*/
    }

    override var representedObject: Any? {
        didSet {
            //print("did set")
            // Update the view, if already loaded.
        }
    }

}

