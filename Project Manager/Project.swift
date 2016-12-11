//
//  IProjectObject.swift
//  Project Manager
//
//  Created by Student on 11/3/16.
//  Copyright © 2016 Hunter Pollpeter. All rights reserved.
//

import UIKit

class Project: SectionObject, NSCoding {
    
    init(name: String, details: String = "", start: NSDate, deadline: NSDate) {
        super.init()
        self.properties = ["Name": name,
                           "Details": details,
                           "Start": start,
                           "Deadline": deadline,
                           "Complete": false]
        self.childSections = []
        self.tableSections.append("Phases")
    }

    override func percentComplete() -> Float {
        var complete = 0
        var total = 0
        for child in childSections {
            complete += child.childSections.filter({$0.properties["Complete"] as! Bool}).count
            total += child.childSections.count
        }
        
        return Float(complete) / Float(total)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(properties, forKey: "properties")
        aCoder.encodeObject(tableSections, forKey: "tableSections")
        aCoder.encodeObject(childSections, forKey: "childSections")
        aCoder.encodeObject(parent, forKey: "parent")
        aCoder.encodeObject(baseProperties, forKey: "baseProperties")
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init()
        tableSections = aDecoder.decodeObjectForKey("tableSections") as! [String]
        properties = aDecoder.decodeObjectForKey("properties") as! [String: AnyObject]
        childSections = aDecoder.decodeObjectForKey("childSections") as! [SectionObject]
        parent = aDecoder.decodeObjectForKey("parent") as? SectionObject
        baseProperties = aDecoder.decodeObjectForKey("baseProperties") as! [String]
    }
}
