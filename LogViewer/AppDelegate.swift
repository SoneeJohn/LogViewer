//
//  AppDelegate.swift
//  LogViewer
//
//  Created by Soneé John on 03/02/2021.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var windowController: MainWindowController?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        let alert = NSAlert()
        alert.messageText = "Please open logs to load"
        alert.informativeText = "Open the zip file to view logs."
        alert.addButton(withTitle: "Open")
        alert.addButton(withTitle: "Cancel")
        guard alert.runModal() == .alertFirstButtonReturn else {
            NSApp.terminate(nil)
            return
        }
        
        let openPanel = NSOpenPanel()
        openPanel.canChooseDirectories = false
        openPanel.allowsMultipleSelection = false
        openPanel.allowedFileTypes = ["zip"]
        
        guard openPanel.runModal() == .OK else {
            NSApp.terminate(nil)
            return
        }
        
        guard let zipURL = openPanel.url else {
            NSApp.terminate(nil)
            return
        }
        
        LogReaderClient.shared.fetchLogs(zipFileURLPath: zipURL) { [unowned self] (log) in
            guard log == nil else {
                self.windowController = MainWindowController.loadFromStoryboard()
                self.windowController?.showWindow(nil)
                return
            }
            
            let alert = NSAlert()
            alert.alertStyle = .warning
            alert.messageText = "Error in loading logs"
            alert.informativeText = "Could not parse logs quitting now"
            NSApp.terminate(nil)
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

