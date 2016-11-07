//
//  PhasesViewController.swift
//  Project Manager
//
//  Created by Student on 11/7/16.
//  Copyright © 2016 Hunter Pollpeter. All rights reserved.
//

import UIKit

class PhasesViewController: UITableViewController {
    var project: Project!
    
    override func viewDidLoad() {
        if let project = project {
            navigationItem.title = project.name
        }
    }
    
    // MARK: - TableView Delegate
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("hello")
        if segue.identifier == "PhaseTasks" {
            let navController = segue.destinationViewController as! UINavigationController
            let tasksViewController =  navController.topViewController as! TasksViewController
            let cell = sender as! UITableViewCell
            tasksViewController.phase = project.phases[tableView.indexPathForCell(cell)!.row]
        }
    }
    
    // MARK: - TableView DataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return project.phases.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell", forIndexPath: indexPath)
        let phase = project.phases[indexPath.row]
        
        cell.textLabel?.text = phase.name
        cell.detailTextLabel?.text = "These are some details about this phase"
        
        return cell
    }
}
