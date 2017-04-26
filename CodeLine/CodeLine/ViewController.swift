//
//  ViewController.swift
//  CodeLine
//
//  Created by quentin on 2017/4/25.
//  Copyright © 2017年 Quentin. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    var backgroundImage: DragView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        backgroundImage = DragView.init(frame: self.view.frame)
        self.view.addSubview(backgroundImage!)
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

