//
//  LogReaderOperation.swift
//  LogViewer
//
//  Created by Soneé John on 03/02/2021.
//

import Foundation
import Zip

class LogReaderClient {
    private let queue: OperationQueue
    static let shared = LogReaderClient()
    var logs: [Log]? = []
    init() {
        self.queue = OperationQueue()
    }
    
    func fetchLogs(zipFileURLPath: URL, completionHandler: (([Log]?) -> Void)?) {
        let operation = LogReaderOperation(zipFileURLPath: zipFileURLPath)
        
        operation.completionBlock = { [unowned self] in
            DispatchQueue.main.async {
                operation.logs?.forEach({ (log) in
                    self.logs?.append(log)
                })
                completionHandler?(operation.logs)
            }
        }
        
        queue.addOperation(operation)
    }
}

class LogReaderOperation: Operation {
    
    override var isAsynchronous: Bool { return true }
    override var isFinished: Bool { return state == .finished }
    override var isExecuting: Bool { return state == .executing }
    
    private var _logs: [Log]?
    public var logs: [Log]? {
        return _logs
    }
    private enum State: String {
        case ready = "Ready"
        case executing = "Executing"
        case finished = "Finished"
        fileprivate var keyPath: String { return "is" + self.rawValue }
    }
    
    private var state: State = .ready {
        willSet {
            willChangeValue(forKey: state.keyPath)
            willChangeValue(forKey: newValue.keyPath)
        }
        didSet {
            didChangeValue(forKey: state.keyPath)
            didChangeValue(forKey: oldValue.keyPath)
        }
    }
    
    public let zipFileURLPath: URL
    
    init(zipFileURLPath: URL) {
        self.zipFileURLPath = zipFileURLPath
        super.init()
    }
    
    override func start() {
        guard isFinished == false else { return }
        
        let directory = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(ProcessInfo.processInfo.globallyUniqueString)
        guard ((try? Zip.unzipFile(zipFileURLPath, destination: directory, overwrite: false, password: nil)) != nil) else {
            finish(logs: nil)
            return
        }
        let logsDirectory = directory.appendingPathComponent("Logs")
        
        guard let contents = try? FileManager.default.contentsOfDirectory(atPath: logsDirectory.path) else {
            finish(logs: nil)
            return
        }
        guard contents.contains("com.flexibits.fantastical2.mac") else {
            finish(logs: nil)
            return
        }
        let mainAppLogDirectory = logsDirectory.appendingPathComponent("com.flexibits.fantastical2.mac")
        
        finish(logs: LogReaderOperation.processLogs(directoryURL: mainAppLogDirectory))
    }
    
    func finish(logs: [Log]?) {
        _logs = logs
        state = .finished
    }
}

extension LogReaderOperation {
    static func processLogs(directoryURL: URL) -> [Log]? {
        guard let contents = try? FileManager.default.contentsOfDirectory(atPath: directoryURL.path) else { return nil }
       
        var logURLs: [URL] = []
        var logs: [Log] = []
        contents.forEach { (logFileName) in
            let url = directoryURL.appendingPathComponent(logFileName)
            guard url.pathExtension == "log" else { return }
            logURLs.append(url)
        }
        
        logURLs.forEach { (logURL) in
            guard let contents = try? String(contentsOf: logURL) else { return }
           
            let lines = contents.split(separator: "\n")
            enum ProcessingType {
                case accounts
                case calendars
                case syncQueues
                case none
            }
            var type: ProcessingType = .none
            
            var accountLines: [String] = []
            var calendarLines: [String] = []
            var syncQueueLines: [String] = []
            
            lines.forEach { (line) in
                if line.contains("Accounts:") {
                    type = .accounts
                } else if line.contains("Calendars:") {
                    type = .calendars
                } else if line.contains("Sync queues:") {
                    type = .syncQueues
                }
                
                switch type {
                case .accounts:
                    if line.contains("Accounts:") == false {
                        accountLines.append(String(line))
                    }
                case .calendars:
                    if line.contains("Calendars:") == false {
                        calendarLines.append(String(line))
                    }
                case .syncQueues:
                    if line.contains("FBSyncQueue") || line.contains(")>") {
                        syncQueueLines.append(String(line))
                    }
                default: break
                }
            }
            
            guard let log = Log(logFileURL: logURL, accountStrings: accountLines, calendarStrings: calendarLines, syncQueueStrings: syncQueueLines) else { return }
            logs.append(log)
        }
        
        guard logs.isEmpty == false else { return nil }
        return logs
    }
}
