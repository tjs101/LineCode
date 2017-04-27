//
//  CodeCellView.swift
//  CodeLine
//
//  Created by quentin on 2017/4/26.
//  Copyright © 2017年 Quentin. All rights reserved.
//

import Foundation
import Cocoa

enum CellType {
    case file
    case folder
}

class CodeCellView: NSView {
    
    static let cellHeight: CGFloat = 78
    
    var iconImageView: NSImageView?
    var titleLabel: NSTextField?
    var countLabel: NSTextField?
    private var finishedImageView: NSImageView?
    
    var cellType: CellType?
    var finished: Bool = false
    var filePath: String?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        // icon imageView
        iconImageView = NSImageView.init()
        self.addSubview(iconImageView!)
        
        // finished imageView
        finishedImageView = NSImageView.init(image: NSImage.init(named: "finished")!)
        self.addSubview(finishedImageView!)
        
        // title label
        titleLabel = NSTextField.init()
        titleLabel?.alignment = NSTextAlignment.left
        titleLabel?.isEditable = false
        titleLabel?.isBordered = false
        titleLabel?.isEnabled = false
        titleLabel?.backgroundColor = NSColor.clear
        titleLabel?.font = NSFont.boldSystemFont(ofSize: 13)
        titleLabel?.textColor = NSColor.black
        self.addSubview(titleLabel!)
        
        // count label
        countLabel = NSTextField.init()
        countLabel?.alignment = NSTextAlignment.left
        countLabel?.isEditable = false
        countLabel?.isBordered = false
        countLabel?.isEnabled = false
        countLabel?.backgroundColor = NSColor.clear
        countLabel?.font = NSFont.boldSystemFont(ofSize: 13)
        countLabel?.textColor = NSColor.red
        self.addSubview(countLabel!)
    }

    override func layout() {
        super.layout()
        
        var x: CGFloat = 0 , y: CGFloat = 0
        
        // icon
        var iconImage: NSImage = NSImage.init(named: "file")!
        
        if cellType == CellType.folder {
            iconImage = NSImage.init(named: "folder")!
        }
        
        x = 10
        y = (self.frame.height - iconImage.size.height) / 2
        
        iconImageView?.image = iconImage
        iconImageView?.frame = NSMakeRect(x, y, iconImage.size.width, iconImage.size.height)
        
        // folder name
        x = 58 + 10
        y = self.frame.height - 20 - 15
        titleLabel?.frame = NSMakeRect(x, y, self.frame.width - x, 20);
        
        // count 
        y = 15
        countLabel?.frame = NSMakeRect(x, y, titleLabel!.frame.width, 20);
        
        // finished
        x = self.frame.width - 32 - 10
        y = (self.frame.height - 32) / 2
        finishedImageView?.isHidden = !finished
        finishedImageView?.frame = NSMakeRect(x, y, 32, 32);
    }
    
}
