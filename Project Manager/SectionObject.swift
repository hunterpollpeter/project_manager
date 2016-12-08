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
    var baseProperties = ["Name", "Details", "Start", "Deadline", "Complete"]
    
    func addChildSectionObject(child: SectionObject) {
        child.parent = self
        childSections.append(child)
        checkComplete()
    }
    
    func removeObject(object: AnyObject) {
        switch object {
        case is SectionObject:
            let index = childSections.indexOf(object as! SectionObject)
            childSections.removeAtIndex(index!)
            checkComplete()
        default:
            let key = object as! String
            properties.removeValueForKey(key)
        }
        
    }
    
    func toggleComplete() {
        let complete = properties["Complete"] as! Bool
        properties["Complete"] = !complete
        checkComplete()
    }
    
    func percentComplete() -> Float {
        let complete = childSections.filter({$0.properties["Complete"] as! Bool})
        return Float(complete.count) / Float(childSections.count)
    }
    
    func checkComplete() {
        if !(self is Task) {
            properties["Complete"] = percentComplete() == 1
        }
        parent?.checkComplete()
    }
}
