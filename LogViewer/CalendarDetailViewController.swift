//
//  CalendarDetailViewController.swift
//  LogViewer
//
//  Created by Soneé John on 04/02/2021.
//

import Cocoa

class CalendarDetailViewController: NSViewController {
    static func loadFromStoryboard() -> CalendarDetailViewController {
        let vc = NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: "CalendarDetailViewControllerStoryboardID")
        
        return vc as! CalendarDetailViewController
    }
    
    @objc lazy dynamic var calendars: [Calendar]? = LogReaderClient.shared.logs?.first?.calendars
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
