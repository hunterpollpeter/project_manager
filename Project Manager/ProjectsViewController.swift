//
//  ViewController.swift
//  Project Manager
//
//  Created by Student on 11/3/16.
//  Copyright © 2016 Hunter Pollpeter. All rights reserved.
//

import UIKit

class ProjectsViewController: UITableViewController {
    var projectStore: ProjectStore!
    
    @IBAction func addNewProject(sender: AnyObject) {
        let newProject = projectStore.createProject()
        
        if let index = projectStore.allProjects.indexOf(newProject) {
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
    
    // MARK: - TableView Delegate
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ProjectPhases" {
            let phasesViewController = segue.destinationViewController as! PhasesViewController
            phasesViewController.cell = sender as! UITableViewCell
        }
    }
    
    // MARK: - TableView DataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projectStore.allProjects.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell", forIndexPath: indexPath)
        let project = projectStore.allProjects[indexPath.row]
        
        cell.textLabel?.text = project.name
        cell.detailTextLabel?.text = "These are some details about this project"
        
        return cell
    }
}

