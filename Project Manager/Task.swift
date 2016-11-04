//
//  Task.swift
//  Project Manager
//
//  Created by Student on 11/3/16.
//  Copyright © 2016 Hunter Pollpeter. All rights reserved.
//

import Foundation

class Task: NSObject {
    var name: String!
    var details: String?
    var notes: String?
    var start: NSDate!
    var deadLine: NSDate!
    var started: Bool!
    var complete: Bool!
    
    init(name: String, start: NSDate, deadLine: NSDate) {
        self.name = name
        self.start = start
        self.deadLine = deadLine
        self.started = false
        self.complete = false
        
        super.init()
    }
    
    convenience init(random: Bool = false) {
        if random {
            let names = ["Finish This", "Fix That", "Work on these", "Get some sleep"]
            
            let idx = arc4random_uniform(UInt32(names.count))
            let randomName = names[Int(idx)]
            
            self.init(name: randomName, start: NSDate(), deadLine: NSDate())
        }
        else {
            self.init(name: "No Name", start: NSDate(), deadLine: NSDate())
        }
    }
}