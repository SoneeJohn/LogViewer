//
//  DetailTabViewController.swift
//  LogViewer
//
//  Created by Soneé John on 04/02/2021.
//

import Cocoa

class DetailTabViewController: NSTabViewController {
    lazy var detailViewControllers: [NSViewController] = {
        return [AccountDetailViewController.loadFromStoryboard(), CalendarDetailViewController.loadFromStoryboard(), SyncQueueDetailViewController.loadFromStoryboard()]
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("SelectedSourceItemDidChanage"), object: nil, queue: .main) { [unowned self] (note) in
            guard let selectedSourceListItem = note.object as? SourceListItem else { return }
            self.detailViewControllers.forEach { (controller) in
                self.addTabViewItem(NSTabViewItem(viewController: controller))
            }
            guard let selectedIndex = self.selectedIndexFor(selectedSourceListItem) else { return }
            self.tabView.selectTabViewItem(at: selectedIndex)
        }
    }
    
    func selectedIndexFor(_ item: SourceListItem) -> Int? {
        for tabViewItem in tabViewItems {
            switch item.type {
            case .account:
                if tabViewItem.viewController is AccountDetailViewController {
                    return tabView.indexOfTabViewItem(tabViewItem)
                }
            case .syncQueue:
                if tabViewItem.viewController is SyncQueueDetailViewController {
                    return tabView.indexOfTabViewItem(tabViewItem)
                }
            case .calendar:
                if tabViewItem.viewController is CalendarDetailViewController {
                    return tabView.indexOfTabViewItem(tabViewItem)
                }
            }
        }
        return nil
    }
}
