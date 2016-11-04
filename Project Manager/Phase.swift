//
//  Phase.swift
//  Project Manager
//
//  Created by Student on 11/3/16.
//  Copyright © 2016 Hunter Pollpeter. All rights reserved.
//

import Foundation

class Phase: NSObject {
    var name: String!
    var details: String?
    var notes: String?
    var start: NSDate!
    var deadLine: NSDate!
    var started: Bool!
    var tasks: [Task]!
    
    var complete: Bool {
        for task in tasks {
            if !task.complete {
                return false
            }
        }
        return true
    }
    
    init(name: String, start: NSDate, deadLine: NSDate) {
        self.name = name
        self.start = start
        self.deadLine = deadLine
        self.started = false
        self.tasks = []
        
        super.init()
    }

    convenience init(random: Bool = false) {
        if random {
            let names = ["Cool Phase", "Fun Phase", "Hard Phase", "Easy Phase"]
            
            let idx = arc4random_uniform(UInt32(names.count))
            let randomName = names[Int(idx)]
            
            self.init(name: randomName, start: NSDate(), deadLine: NSDate())
            
            let randomValue = arc4random_uniform(10)
            for _ in 0...randomValue {
                self.tasks.append(Task(random: true))
            }
        }
        else {
            self.init(name: "No Name", start: NSDate(), deadLine: NSDate())
        }
    }
}