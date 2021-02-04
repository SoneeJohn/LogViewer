//
//  Log.swift
//  LogViewer
//
//  Created by Soneé John on 04/02/2021.
//

import Foundation

struct Log {
    let accounts: [Account]
    let calendars: [Calendar]
    let syncQueue: [SyncQueue]
    let logFileURL: URL
    
    init?(logFileURL: URL, accountStrings: [String], calendarStrings: [String], syncQueueStrings: [String]) {
        guard accountStrings.isEmpty == false else { return nil }
        guard calendarStrings.isEmpty == false else { return nil }
        guard syncQueueStrings.isEmpty == false else { return nil }
        
        accounts = accountStrings.compactMap{ Account($0) }
        calendars = calendarStrings.compactMap{ Calendar($0) }
        syncQueue = syncQueueStrings.compactMap { SyncQueue($0) }
        self.logFileURL = logFileURL
    }
}

@objcMembers class Calendar: NSObject {
    let name: String
    let identifier: String
    let numberOfEvents: Int
    private let string: String
    init?(_ string: String) {
        guard let stringWithoutDate = string.split(separator: "\t").last else { return nil }
        self.string = string
        
        let properties = stringWithoutDate.split(separator: ",").compactMap { (sub) -> String in
            return String(sub).trimmingCharacters(in: .whitespacesAndNewlines)
        }
        guard properties.count >= 2 else { return nil }
     
        guard let numberOfEventsString = self.string.firstGroupMatch(for: #"count: (\d+)"#) else { return nil }
        self.numberOfEvents = Int(numberOfEventsString) ?? 0
        self.name = properties[0]
        self.identifier = properties[1]
    }
}

@objcMembers class Account: NSObject {
    private let string: String
    let name: String
    let identifier: String
    let state: Bool
    let framework: String
    init?(_ string: String) {
        guard let stringWithoutDate = string.split(separator: "\t").last else { return nil }
        self.string = string
        
        let properties = stringWithoutDate.split(separator: ",").compactMap { (sub) -> String in
            return String(sub).trimmingCharacters(in: .whitespacesAndNewlines)
        }
        guard properties.count >= 4 else { return nil }
        
        self.name = properties[0]
        self.identifier = properties[1]
        self.state = properties[2].contains("enabled")
        self.framework = properties[3]
    }
}

@objcMembers class SyncQueue: NSObject {
    let name: String
    let identifier: String
    private let string: String
    init?(_ string: String) {
        guard let properties = SyncQueue.properties(string) else { return nil }
        
        self.name = properties[0]
        self.identifier = properties[1]
        self.string = string
    }
    
    static func properties(_ string: String) -> [String]? {
        var properties: [String] = []
        
        if string.contains("Sync queues:") {
            guard let firstGroup = string.groups(for: #"(?:[^\\\\s]+)s: ([\S]+) \/ ([^(\s]+)"#).first else { return nil }
            guard firstGroup.count >= 3 else { return nil }
            properties.append(firstGroup[1])
            properties.append(firstGroup[2])
            return properties
        }
        
        guard let firstGroup = string.groups(for: #"([\S]+) \/ (\S*)"#).first else { return nil }
        guard firstGroup.count >= 3 else { return nil }
        properties.append(firstGroup[1])
        properties.append(firstGroup[2])
        
        guard properties.isEmpty == false else { return nil }
        return properties
    }
}

extension String {
    func matches(for regex: String, options: NSRegularExpression.Options = NSRegularExpression.Options()) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex, options: options)
            let results = regex.matches(in: self,
                                        range: NSRange(self.startIndex..., in: self))
            return results.map {
                String(self[Range($0.range, in: self)!])
            }
        } catch let error {
            print("Invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
    func firstGroupMatch(for regexPattern: String, options: NSRegularExpression.Options = NSRegularExpression.Options()) -> String? {
        let group = groups(for: regexPattern)
        guard group.isEmpty == false else { return nil }
        guard group[0].count >= 2 else { return nil }
        return group[0][1]
    }
    
    func groups(for regexPattern: String, options: NSRegularExpression.Options = NSRegularExpression.Options()) -> [[String]] {
        do {
            let text = self
            let regex = try NSRegularExpression(pattern: regexPattern, options: options)
            let matches = regex.matches(in: text,
                                        range: NSRange(text.startIndex..., in: text))
            return matches.map { match in
                return (0..<match.numberOfRanges).map {
                    let rangeBounds = match.range(at: $0)
                    guard let range = Range(rangeBounds, in: text) else {
                        return ""
                    }
                    return String(text[range])
                }
            }
        } catch let error {
            print("Invalid regex: \(error.localizedDescription)")
            return []
        }
    }
}
