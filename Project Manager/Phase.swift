//
//  Phase.swift
//  Project Manager
//
//  Created by Student on 11/3/16.
//  Copyright © 2016 Hunter Pollpeter. All rights reserved.
//

import Foundation

class Phase: SectionObject {

    init(name: String, details: String = "", start: NSDate, deadline: NSDate) {
        super.init()
        self.properties = ["Name": name,
                           "Details": details,
                           "Start": start,
                           "Deadline": deadline,
                           "Complete": false]
        self.childSections = []
        self.tableSections.append("Tasks")
    }
    
    convenience init(random: Bool = false) {
        if random {
            let names = ["Cool Phase", "Fun Phase", "Hard Phase", "Easy Phase"]
            
            let idx = arc4random_uniform(UInt32(names.count))
            let randomName = names[Int(idx)]
            
            self.init(name: randomName, start: NSDate(), deadline: NSDate())
            
            let randomValue = arc4random_uniform(10)
            for _ in 0...randomValue {
                self.addChildSectionObject(Task(random: true))
            }
            self.properties["Details"] = "These are some details about this phase"
        }
        else {
            self.init(name: "No Name", start: NSDate(), deadline: NSDate())
        }
    }
}