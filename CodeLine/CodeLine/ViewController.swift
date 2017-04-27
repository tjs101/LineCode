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
//        backgroundImage = DragView.init(frame: NSMakeRect(0, 0, 550, 350))
        self.view.addSubview(backgroundImage!)
    
        self.perform(#selector(ViewController.onClick), with: self, afterDelay: 10)
    }
    
    func onClick() {
        self.view.frame = NSMakeRect(0, 0, 550, 350)
        viewDidLayout()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

