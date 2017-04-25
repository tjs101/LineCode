//
//  ViewController.swift
//  CodeLine
//
//  Created by quentin on 2017/4/25.
//  Copyright © 2017年 Quentin. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.layer?.backgroundColor = CGColor.init(red: 6, green: 6, blue: 6, alpha: 1)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

