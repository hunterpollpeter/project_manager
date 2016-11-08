//
//  IProjectObject.swift
//  Project Manager
//
//  Created by Student on 11/3/16.
//  Copyright © 2016 Hunter Pollpeter. All rights reserved.
//

import UIKit

class Project: NSObject {
    var name: String!
    var details: String?
    var notes: String?
    var start: NSDate!
    var deadLine: NSDate!
    var started: Bool!
    var phases: [Phase]!
    
    var complete: Bool {
        for phase in phases {
            if !phase.complete {
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
        self.phases = []
        
        super.init()
    }
    
    convenience init(random: Bool = false) {
        if random {
            let names = ["Cool Project", "Fun Project", "Hard Project", "Easy Project"]
            
            let idx = arc4random_uniform(UInt32(names.count))
            let randomName = names[Int(idx)]
            
            self.init(name: randomName, start: NSDate(), deadLine: NSDate())
            
            let randomValue = arc4random_uniform(10)
            for _ in 0...randomValue {
                self.phases.append(Phase(random: true))
            }
        }
        else {
            self.init(name: "No Name", start: NSDate(), deadLine: NSDate())
        }
    }
}
