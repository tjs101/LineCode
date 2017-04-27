//
//  SettingsViewController.swift
//  CodeLine
//
//  Created by quentin on 2017/4/27.
//  Copyright © 2017年 Quentin. All rights reserved.
//

import Foundation
import Cocoa

class SettingsViewController: NSViewController {
    
    @IBOutlet var checkFileTypeTextField: NSTextField?
    @IBOutlet var uncheckFolderTextField: NSTextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
}
