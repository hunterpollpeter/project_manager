//
//  SectionObject.swift
//  Project Manager
//
//  Created by Student on 12/5/16.
//  Copyright © 2016 Hunter Pollpeter. All rights reserved.
//

import Foundation

class SectionObject: NSObject {
    var tableSections = ["Properties"]
    var properties: [String: AnyObject]!
    var childSections: [SectionObject]!
    var parent: SectionObject?
    
    func addChildSectionObject(child: SectionObject) {
        child.parent = self
        childSections.append(child)
        checkComplete()
    }
    
    func toggleComplete() {
        let complete = properties["Complete"] as! Bool
        properties["Complete"] = !complete
        parent!.checkComplete()
    }
    
    func percentComplete() -> Float {
        let complete = childSections.filter({$0.properties["Complete"] as! Bool})
        return Float(complete.count) / Float(childSections.count)
    }
    
    func checkComplete() {
        properties["Complete"] = percentComplete() == 1
        if let parent = parent {
            parent.checkComplete()
        }
    }
}
