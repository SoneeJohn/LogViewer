//
//  AppDelegate.swift
//  LogViewer
//
//  Created by Soneé John on 03/02/2021.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var mainWindowController: MainWindowController?
    var splitViewWindowController: SplitViewWindowController?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        self.mainWindowController = MainWindowController()
        self.mainWindowController?.showWindow(nil)
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("LogsDidLoad"), object: nil, queue: .main) { [unowned self] (_) in
            
            self.mainWindowController?.close()
            
            self.splitViewWindowController = SplitViewWindowController.loadFromStoryboard()
            
            NSApp.activate(ignoringOtherApps: true)
            self.splitViewWindowController?.window?.makeKeyAndOrderFront(nil)
            
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    static func jsonDataFrom(_ log: Log) -> Data? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        return try? encoder.encode(log)
    }
    
    @IBAction func dropLogs(_ sender: NSMenuItem) {
        guard let log = LogReaderClient.shared.logs?.first else { return }
        
        let savePanel = NSSavePanel()
        savePanel.nameFieldStringValue = "Fantastical Logs.json"
        savePanel.prompt = "Dump"
        
        guard savePanel.runModal() == .OK else { return }
        guard let data = AppDelegate.jsonDataFrom(log) else { return }
        guard let saveURL = savePanel.url else { return }
        guard ((try? data.write(to: saveURL)) != nil) else { return }
        
        NSWorkspace.shared.activateFileViewerSelecting([saveURL])
        
    }
    
}

