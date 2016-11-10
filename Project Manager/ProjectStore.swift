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
    
    func createProject() -> Project {
        let newProject = Project(random: true)
        
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
    
    
    init() {
        for _ in 0..<5 {
            createProject()
        }
    }
}