//
//  SyncQueueDetailViewController.swift
//  LogViewer
//
//  Created by Soneé John on 04/02/2021.
//

import Cocoa

class SyncQueueDetailViewController: NSViewController {
    static func loadFromStoryboard() -> SyncQueueDetailViewController {
        let vc = NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: "SyncQueueDetailViewControllerStoryboardID")
        
        return vc as! SyncQueueDetailViewController
    }
    
    @objc lazy dynamic var syncQueues: [SyncQueue]? = LogReaderClient.shared.logs?.first?.syncQueue
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
