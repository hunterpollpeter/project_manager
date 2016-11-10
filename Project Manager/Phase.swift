//
//  Phase.swift
//  Project Manager
//
//  Created by Student on 11/3/16.
//  Copyright © 2016 Hunter Pollpeter. All rights reserved.
//

import Foundation

class Phase: NSObject {
    let dateFormatter: NSDateFormatter = {
        let df = NSDateFormatter()
        df.dateStyle = NSDateFormatterStyle.MediumStyle
        return df
    }()
    var name: String!
    var details: String?
    var notes: [String]?
    var start: NSDate!
    var deadline: NSDate!
    var started: Bool!
    var tasks: [Task]!
    
    var completion: Int {
        let totalTasks = tasks.count
        let tasksComplete = tasks.filter {(task: Task) -> Bool in
            return task.complete
        }.count
        return Int(tasksComplete / totalTasks * 100)
    }
    
    var generalInformation: [(String, Any)] {
        var gi = [(String, Any)]()
        let mirror = Mirror(reflecting: self)
        for property in mirror.children {
            
            if String(property.value) != "nil" {
                gi.append((property.label!, property.value))
            }
        }
        return gi
    }
    
    var complete: Bool
    
    init(name: String, start: NSDate, deadLine: NSDate) {
        self.name = name
        self.start = start
        self.deadline = deadLine
        self.started = false
        self.tasks = []
        self.complete = false
        
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
            
//            self.notes = ["Cool note", "Weird note"]
            self.complete = true
        }
        else {
            self.init(name: "No Name", start: NSDate(), deadLine: NSDate())
        }
    }
}