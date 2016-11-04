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
    var currentProject: Project? {
        for project in allProjects {
            if project.currentProject == true {
                return project
            }
        }
        return nil
    }
    
    func createProject() -> Project {
        let newProject = Project(random: true)
        newProject.currentProject = allProjects.isEmpty
        
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
    
    func setProjectAtIndexToCurrent(index: Int) {
        for project in allProjects {
            project.currentProject = false
        }
        allProjects[index].currentProject = true
    }
    
    init() {
        for _ in 0..<5 {
            createProject()
        }
    }
}