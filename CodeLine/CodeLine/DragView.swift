//
//  DragView.swift
//  CodeLine
//
//  Created by quentin on 2017/4/25.
//  Copyright © 2017年 Quentin. All rights reserved.
//

import Foundation
import Cocoa

class DragView: NSImageView {
    
    var placeholderImageView: NSImageView?
    var placeholderTitleLabel: NSTextField?
    var settingsBtn: NSButton?
    var totalTitleLabel: NSTextField?
    
    // 文件变量
    var fileCount: Int = 0 // 文件数量
    var dirCount: Int  = 0 // 文件夹数量
    var fileLineCount: Int = 0 // 多少行代码
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
     
        // background
        self.image = NSImage.init(named: "background")
        
        var x: CGFloat = 0, y: CGFloat = 0
        let width: CGFloat = 130, height: CGFloat = width
        
        // placeholder imageView
        let placeholderImage: NSImage = NSImage.init(named: "placeholder")!
        
        placeholderImageView = NSImageView.init(image: placeholderImage)
        self.addSubview(placeholderImageView!)
        
        // placeholder title label
        placeholderTitleLabel = NSTextField.init(string: "Drag the file/directiory")
        placeholderTitleLabel?.alignment = NSTextAlignment.center
        placeholderTitleLabel?.isEditable = false
        placeholderTitleLabel?.isBordered = false
        placeholderTitleLabel?.isEnabled = false
        placeholderTitleLabel?.backgroundColor = NSColor.clear
        placeholderTitleLabel?.font = NSFont.systemFont(ofSize: 18)
        self.addSubview(placeholderTitleLabel!)
        
        x = (self.frame.width - width) / 2
        y = (self.frame.height - height + 30) / 2
        
        placeholderImageView?.frame = NSMakeRect(x, y, width, height)
        
        x = 15
        y = placeholderImageView!.frame.origin.y - 30
        placeholderTitleLabel?.frame = NSMakeRect(x, y, self.frame.width - 2 * x, 30)
        
        // settings btn
        let settingImage: NSImage = NSImage.init(named: "setting")!
        
        x = self.frame.width - settingImage.size.width - 10
        y = 10
        
        settingsBtn = NSButton.init(image: settingImage, target: self, action: #selector(DragView.onSettingsClick))
        settingsBtn?.isBordered = false
        self.addSubview(settingsBtn!)
        settingsBtn?.frame = NSMakeRect(x, y, settingImage.size.width, settingImage.size.height)
        
        // total title
        x = 10
        y = 10
        
        totalTitleLabel = NSTextField.init()
        totalTitleLabel?.alignment = NSTextAlignment.left
        totalTitleLabel?.isEditable = false
        totalTitleLabel?.isBordered = false
        totalTitleLabel?.isEnabled = false
        totalTitleLabel?.isHidden = true
        totalTitleLabel?.backgroundColor = NSColor.clear
        totalTitleLabel?.font = NSFont.systemFont(ofSize: 14)
        self.addSubview(totalTitleLabel!)
        totalTitleLabel?.frame = NSMakeRect(x, y, settingsBtn!.frame.origin.x - x, 20);
        
        // register bind
        self.register(forDraggedTypes: [NSFilenamesPboardType])
    }
    
    func onSettingsClick() {
        
    }
    
    func updateView() {
        placeholderImageView?.isHidden = true
        placeholderTitleLabel?.isHidden = true
        
        totalTitleLabel?.isHidden = false
        totalTitleLabel?.stringValue = String.init(format: "共%d个文件 %d行代码", fileCount + dirCount, fileLineCount)
    }
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        
        return NSDragOperation.copy
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        
        let pasteBoard: NSPasteboard = sender.draggingPasteboard()

        let filePaths: NSArray = pasteBoard.propertyList(forType: NSFilenamesPboardType) as! NSArray
        
        NSLog("files path == %@", filePaths)

        for path in filePaths {
            subpathsOfPath(path: path as! String)
        }
        
        updateView()
        
        return true
    }
    
    func subpathsOfPath(path: String) {
        let fileManager: FileManager = FileManager.default
        
        do {
            let paths: NSArray = try fileManager.subpathsOfDirectory(atPath: path) as NSArray
            NSLog("paths==%@", paths)
            
            if paths.count > 0 {
                NSLog("文件夹")
                for aPath in paths {
                    subpathsOfPath(path: String.init(format: "%@/%@", path, aPath as! CVarArg))
                }
            }
            else {
                NSLog("文件")
                fileCount += 1
            }

        } catch {
            NSLog("fileManager error")
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
