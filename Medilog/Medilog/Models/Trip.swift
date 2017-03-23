//
//  Trip.swift
//  Medilog
//
//  Created by Amarnath on 23/03/17.
//  Copyright © 2017 Amarnath. All rights reserved.
//


import Foundation
import Unbox

enum Status: String {
    case Scheduled = "SCHEDULED"
    case Started = "STARTED"
    case Ended = "ENDED"
}

struct Trip {
    let name: String?
    let id: String?
    let start: String?
    let end: String?
    let statusStr: String?
    var startTime: String?
    var endTime: String?
    var statusColor: UIColor?
    var status: Status?
}

extension Trip: Unboxable {
    init(unboxer: Unboxer) throws {
        self.name = unboxer.unbox(key: "display_name")
        self.id = unboxer.unbox(key: "id")
        self.start = unboxer.unbox(key: "start")
        self.end = unboxer.unbox(key: "end")
        self.statusStr = unboxer.unbox(key: "status")
        
        if let s = self.statusStr {
            switch s {
            case Status.Scheduled.rawValue:
                self.status = .Scheduled
                self.statusColor = UIColor.orange
            case Status.Started.rawValue:
                self.status = .Started
                self.statusColor = UIColor.green
            case Status.Ended.rawValue:
                self.status = .Ended
                self.statusColor = UIColor.red
            default: break
            }
        }
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "hh:mm a"

        if let s = self.start,
            let d = Double(s) {
            self.startTime = timeFormatter.string(from: Date(timeIntervalSince1970: d))
        }
        if let e = self.end,
            let d = Double(e) {
            self.endTime = timeFormatter.string(from: Date(timeIntervalSince1970: d))
        }
    }
}
