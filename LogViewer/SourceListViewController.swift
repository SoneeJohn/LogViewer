//
//  SourceListViewController.swift
//  LogViewer
//
//  Created by Soneé John on 04/02/2021.
//

import Cocoa

@objcMembers class SourceListItem: NSObject {
    dynamic let name: String
    dynamic let type: SourceItemType
    init(name: String, type: SourceItemType) {
        self.name = name
        self.type = type
        super.init()
    }
}

enum SourceItemType: Int {
    case account
    case calendar
    case syncQueue
}

class SourceListViewController: NSViewController, NSTableViewDelegate {
    @IBOutlet weak var tableView: NSTableView!
    @objc lazy dynamic var sourceListItems: [SourceListItem] = [SourceListItem(name: "Calendars", type: .calendar), SourceListItem(name: "Accounts", type: .account), SourceListItem(name: "Sync Queues", type: .syncQueue)]
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        let selectedRow = tableView.selectedRow
        guard selectedRow != -1 else { return }
        let sourceItem = sourceListItems[selectedRow]
        NotificationCenter.default.post(name: NSNotification.Name("SelectedSourceItemDidChanage"), object: sourceItem)
        
    }
}
