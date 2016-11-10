//
//  Task.swift
//  Project Manager
//
//  Created by Student on 11/3/16.
//  Copyright © 2016 Hunter Pollpeter. All rights reserved.
//

import Foundation

class Task: NSObject {
    var properties: [String: AnyObject]!
    
    init(name: String, details: String = "", start: NSDate, deadline: NSDate) {
        self.properties = ["Name": name,
                           "Details": details,
                           "Start": start,
                           "Deadline": deadline,
                           "Complete": false]
        super.init()
    }
    
    convenience init(random: Bool = false) {
        if random {
            let names = ["Finish This", "Fix That", "Work on these", "Get some sleep"]
            
            let idx = arc4random_uniform(UInt32(names.count))
            let randomName = names[Int(idx)]
            
            self.init(name: randomName, start: NSDate(), deadline: NSDate())
            self.properties["Complete"] = arc4random_uniform(2) == 1
            self.properties["Details"] = "These are some details about this task"
        }
        else {
            self.init(name: "No Name", start: NSDate(), deadline: NSDate())
        }
    }
}