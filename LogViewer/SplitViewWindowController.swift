//
//  SplitViewWindowController.swift
//  LogViewer
//
//  Created by Soneé John on 09/02/2021.
//

import Cocoa

class SplitViewWindowController: NSWindowController {
    static func loadFromStoryboard() -> SplitViewWindowController {
        let vc = NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: "SplitViewWindowControllerStoryboardID")
        
        return vc as! SplitViewWindowController
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        window?.center()
    }
}
