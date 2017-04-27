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
    var bgScrollView: NSScrollView?
    
    // 文件变量
    var fileCount: Int = 0 // 文件数量
    var fileLineCount: Int = 0 // 多少行代码
    
    var currentFileCount: Int = 0 // 当前文件数量
    var currentFileLineCount: Int = 0 // 当前多少行代码

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
     
        // background
        self.image = NSImage.init(named: "background")
        
        // bg scroll view
        bgScrollView = NSScrollView.init(frame: NSMakeRect(0, 50, self.frame.width, self.frame.height - 50))
        bgScrollView?.backgroundColor = NSColor.init(patternImage: NSImage.init(named: "background")!)
        self.addSubview(bgScrollView!)
        
        var x: CGFloat = 0, y: CGFloat = 0
        let width: CGFloat = 130, height: CGFloat = width
        
        // placeholder imageView
        let placeholderImage: NSImage = NSImage.init(named: "placeholder")!
        
        placeholderImageView = NSImageView.init(image: placeholderImage)
        placeholderImageView?.isEnabled = false
        placeholderImageView?.isEditable = false
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

        let storyboard: NSStoryboard = NSStoryboard.init(name: "Main", bundle: nil)
        let settingsViewCtrl: NSViewController = storyboard.instantiateController(withIdentifier: "settings") as! NSViewController
        let initViewCtrl: NSViewController = storyboard.instantiateController(withIdentifier: "init") as! NSViewController
        initViewCtrl.presentViewControllerAsModalWindow(settingsViewCtrl)
        
    }
    
    func updateView(filePath: String, fileCount: Int, fileLineCount: Int) {
        placeholderImageView?.isHidden = true
        placeholderTitleLabel?.isHidden = true
        
        totalTitleLabel?.isHidden = false
        totalTitleLabel?.stringValue = String.init(format: "共%d个文件 %d行代码", fileCount, fileLineCount)
//        totalTitleLabel?.attributedStringValue = NSAttributedString.init(string: "adf", attributes: [NSForegroundColorAttributeName : NSColor.red])
//        
//        NSMutableAttributedString
        
        if filePath != "" {
            for view in bgScrollView!.subviews {
                
                if view.isKind(of: CodeCellView.self) {
                    
                    let cellView: CodeCellView = view as! CodeCellView
                    
                    if cellView.filePath == filePath {
                        cellView.finished = true
                        cellView.layout()
                        cellView.countLabel?.stringValue = String.init(format: "%d个文件 %d行代码", fileCount, fileLineCount)
                    }
                    
                }
                
            }
        }

    }
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        
        return NSDragOperation.copy
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        
        let pasteBoard: NSPasteboard = sender.draggingPasteboard()

        let filePaths: NSArray = pasteBoard.propertyList(forType: NSFilenamesPboardType) as! NSArray

        for view: NSView in bgScrollView!.subviews {
            if view.isKind(of: CodeCellView.classForCoder()) {
                view.removeFromSuperview()
            }
        }
        
        fileCount = 0
        fileLineCount = 0

        var y: CGFloat = 0
        var index: Int = 1 // 索引
        
        let semaphore: DispatchSemaphore = DispatchSemaphore.init(value: filePaths.count)
        
        for path in filePaths {

            DispatchQueue.global().async(execute: { () -> Void in
                
//                semaphore.wait()

                self.currentFileCount = 0
                self.currentFileLineCount = 0
                
                self.subpathsOfPath(path: path as! String)
                

                DispatchQueue.main.async(execute: {
                    self.updateView(filePath: path as! String, fileCount: self.currentFileCount, fileLineCount: self.currentFileLineCount)
                })
                
//                semaphore.signal()
            })

            // file type
            var fileType: FileAttributeType = FileAttributeType.typeUnknown;
            do {
                let attributes: NSDictionary = try FileManager.default.attributesOfItem(atPath: path as! String) as NSDictionary
                fileType = attributes.object(forKey: FileAttributeKey.type) as! FileAttributeType
            } catch {
                
            }
            
            let cell: CodeCellView = CodeCellView.init(frame: NSMakeRect(0, y, self.frame.width, CodeCellView.cellHeight))
            cell.cellType = (fileType == FileAttributeType.typeDirectory) ? CellType.folder : CellType.file
            cell.titleLabel?.stringValue = String.init(format: "%d.%@", index, filenameWithPath(path: path as! String))
            cell.countLabel?.stringValue = "统计中.."
            cell.filePath = path as? String
            bgScrollView?.addSubview(cell)
            
            y += CodeCellView.cellHeight
            index += 1
        }

        return true
    }
    
    // 所有文件
    func subpathsOfPath(path: String) {
        let fileManager: FileManager = FileManager.default
        
        do {
            let attributes: NSDictionary = try fileManager.attributesOfItem(atPath: path) as NSDictionary
            let fileType: FileAttributeType = attributes.object(forKey: FileAttributeKey.type) as! FileAttributeType

            if fileType == FileAttributeType.typeDirectory {// folder
                
                let paths: NSArray = try fileManager.contentsOfDirectory(atPath: path) as NSArray
                
                if paths.count > 0 {
                    
                    for aPath in paths {
                        
                        self.subpathsOfPath(path: String.init(format: "%@/%@", path, aPath as! CVarArg))
                        
                        DispatchQueue.main.async(execute: {
                            self.updateView(filePath: "", fileCount: 0, fileLineCount: 0)
                        })
                    }
                }
            }
            else { // file
                if filenameWithPath(path: path).hasSuffix(".h") {
                    fileCount += 1
                    currentFileCount += 1
                }
                
                DispatchQueue.main.async(execute: {
                    self.updateView(filePath: "", fileCount: 0, fileLineCount: 0)
                })
            }

        } catch {
            NSLog("fileManager error")
        }
    }

    // 文件名称
    func filenameWithPath(path: String) -> String {
        
        let filenames: NSArray = path.components(separatedBy: "/") as NSArray
        
        return filenames.lastObject as! String
    }
}
