//
//  ProjectStore.swift
//  Project Manager
//
//  Created by Student on 11/3/16.
//  Copyright © 2016 Hunter Pollpeter. All rights reserved.
//

import Foundation

class ProjectStore {
    
    var allProjects = [Project]()
    let projectArchiveURL: NSURL = {
        let documentsDirectories = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.URLByAppendingPathComponent("items.archive")
    }()
    
    func createProject(name: String, details: String, start: NSDate, deadline: NSDate) -> Project {
        let newProject = Project(name: name, details: details, start: start, deadline: deadline)
        
        allProjects.append(newProject)
        
        return newProject
    }
    
    init() {
        if let archivedProjects = NSKeyedUnarchiver.unarchiveObjectWithFile(projectArchiveURL.path!) as? [Project] {
            allProjects += archivedProjects
        }
    }
    
    func removeProjectAtIndex(index: Int) {
        allProjects.removeAtIndex(index)
    }
    
    func moveProjectAtIndex(fromIndex: Int, toIndex: Int) {
        if fromIndex == toIndex {
            return
        }
        
        let movedProject = allProjects[fromIndex]
        allProjects.removeAtIndex(fromIndex)
        allProjects.insert(movedProject, atIndex: toIndex)
    }
    
    func saveChanges() -> Bool {
        print("saved")
        return NSKeyedArchiver.archiveRootObject(allProjects, toFile: projectArchiveURL.path!)
    }
}