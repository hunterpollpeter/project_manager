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
    
    func createProject(name: String, details: String, start: NSDate, deadline: NSDate) -> Project {
        let newProject = Project(name: name, details: details, start: start, deadline: deadline)
        
        allProjects.append(newProject)
        
        return newProject
    }
    
    func removeProject(project: Project) {
        if let index = allProjects.indexOf(project) {
            allProjects.removeAtIndex(index)
        }
    }
    
    func moveProjectAtIndex(fromIndex: Int, toIndex: Int) {
        if fromIndex == toIndex {
            return
        }
        
        let movedProject = allProjects[fromIndex]
        allProjects.removeAtIndex(fromIndex)
        allProjects.insert(movedProject, atIndex: toIndex)
    }
    
    
//    init() {
//        for _ in 0..<5 {
//            createProject()
//        }
//    }
}