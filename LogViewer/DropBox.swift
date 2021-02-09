//
//  DropBox.swift
//  LogViewer
//
//  Created by Soneé John on 09/02/2021.
//

import Cocoa

class DropBox: NSBox {
    
    var dragHandler: ((URL?) -> Void)?
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        registerForDraggedTypes([.fileURL])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        guard let urls = sender.draggingPasteboard.readObjects(forClasses: [NSURL.self], options: nil) as? [URL] else {
            dragHandler?(nil)
            return false
        }
        
        dragHandler?(urls.first)
        return true
    }
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        guard let urls = sender.draggingPasteboard.readObjects(forClasses: [NSURL.self], options: nil) as? [URL] else { return [] }
        
        //Right now we only want to handle 1 log file.
        guard urls.count == 1 else { return [] }
        return .copy
    }
}
