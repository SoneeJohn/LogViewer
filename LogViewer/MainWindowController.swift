//
//  MainWindowController.swift
//  LogViewer
//
//  Created by Soneé John on 04/02/2021.
//

import Cocoa

class MainWindowController: NSWindowController {
    
    static var defaultRect: NSRect {
        return NSRect(x: 0, y: 0, width: 400, height: 200)
    }
    override var windowNibName: NSNib.Name? {
        // Triggers `loadWindow`
        return NSNib.Name("")
    }
    
    init() {
        super.init(window: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadWindow() {
        let mask: NSWindow.StyleMask = [.closable, .miniaturizable, .titled]
        let window = NSWindow(contentRect: MainWindowController.defaultRect, styleMask: mask, backing: .buffered, defer: false, screen: nil)
        
        window.contentViewController = MainViewController(frame: MainWindowController.defaultRect)
        window.title = "Log Viewer"
        window.titlebarAppearsTransparent = true
        window.center()
        self.window = window
    }
}
