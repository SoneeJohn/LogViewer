//
//  MainWindowController.swift
//  LogViewer
//
//  Created by Soneé John on 04/02/2021.
//

import Cocoa

class MainWindowController: NSWindowController {
    static func loadFromStoryboard() -> MainWindowController {
        let vc = NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: "MainWindowControllerStoryboardID")
        
        return vc as! MainWindowController
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        window?.center()
    }
}
