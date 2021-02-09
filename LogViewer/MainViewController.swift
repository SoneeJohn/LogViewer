//
//  MainViewController.swift
//  LogViewer
//
//  Created by Soneé John on 03/02/2021.
//

import Cocoa

class MainViewController: NSViewController {
    
    lazy var dropBox: DropBox = {
        let b = DropBox(frame: .zero)
        
        b.titlePosition = .noTitle
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
    lazy var titleLabel: NSTextField = {
        let t = NSTextField(labelWithString: "Drag log file here")
        
        t.font = .systemFont(ofSize: 40)
        t.translatesAutoresizingMaskIntoConstraints  = false
        return t
    }()
    
    lazy var progressIndicator: NSProgressIndicator = {
        let p = NSProgressIndicator(frame: .zero)
        
        p.translatesAutoresizingMaskIntoConstraints = false
        p.controlSize = .large
        p.isIndeterminate = true
        p.style = .spinning
        return p
    }()
    
    private let frame: NSRect
    static let padding: CGFloat = 20
    
    init(frame: NSRect) {
        self.frame = frame
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func loadView() {
        view = NSView(frame: frame)
        
        view.addSubview(dropBox)
        view.addSubview(titleLabel)
        view.addSubview(progressIndicator)
        
        progressIndicator.isHidden = true
        
        NSLayoutConstraint.activate([
            dropBox.topAnchor.constraint(
                equalTo: view.topAnchor, constant: MainViewController.padding
            ),
            dropBox.bottomAnchor.constraint(
                equalTo: view.bottomAnchor, constant: -MainViewController.padding
            ),
            dropBox.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: -MainViewController.padding
            ),
            dropBox.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: MainViewController.padding
            ),
            titleLabel.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
            titleLabel.centerYAnchor.constraint(
                equalTo: view.centerYAnchor
            ),
            
            progressIndicator.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
            progressIndicator.centerYAnchor.constraint(
                equalTo: view.centerYAnchor
            )
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dropBox.dragHandler = { [unowned self] (fileURL) in
            guard let zipFileURLPath = fileURL else { return }
            
            self.dropBox.isHidden = true
            self.titleLabel.isHidden = true
            self.progressIndicator.isHidden = false
            self.progressIndicator.startAnimation(nil)
            
            LogReaderClient.shared.fetchLogs(zipFileURLPath: zipFileURLPath) { [unowned self] (logs) in
                guard logs != nil else {
                    let alert = NSAlert()
                    alert.alertStyle = .warning
                    alert.messageText = "Error in loading logs"
                    alert.informativeText = "Could not parse logs please try again"
                    alert.runModal()
                    
                    self.resetView()
                    return
                }
                
                // Will use a 0.5 second delay because the data will load quickly
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    NotificationCenter.default.post(Notification(name: Notification.Name("LogsDidLoad")))
                }
            }
        }
    }
    
    private func resetView() {
        self.dropBox.isHidden = false
        self.titleLabel.isHidden = false
        self.progressIndicator.isHidden = true
        self.progressIndicator.stopAnimation(nil)
    }
}
