//
//  SourceListViewController.swift
//  LogViewer
//
//  Created by Soneé John on 04/02/2021.
//

import Cocoa

@objcMembers class SourceListItem: NSObject {
    let name: String
    let type: SourceItemType
    let image: NSImage
    init(name: String, type: SourceItemType, image: NSImage) {
        self.name = name
        self.type = type
        self.image = image
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
    @objc lazy dynamic var sourceListItems: [SourceListItem] = [SourceListItem(name: "Calendars", type: .calendar, image: #imageLiteral(resourceName: "Calendar")), SourceListItem(name: "Accounts", type: .account, image: #imageLiteral(resourceName: "Accounts")), SourceListItem(name: "Sync Queues", type: .syncQueue, image: #imageLiteral(resourceName: "Sync"))]
  
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
