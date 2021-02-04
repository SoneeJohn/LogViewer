//
//  AccountDetailViewController.swift
//  LogViewer
//
//  Created by Soneé John on 04/02/2021.
//

import Cocoa

class AccountDetailViewController: NSViewController {
    static func loadFromStoryboard() -> AccountDetailViewController {
        let vc = NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: "AccountDetailViewControllerStoryboardID")
        
        return vc as! AccountDetailViewController
    }
    
    @objc lazy dynamic var accounts: [Account]? = LogReaderClient.shared.logs?.first?.accounts
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
