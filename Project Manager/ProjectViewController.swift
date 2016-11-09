//
//  PhasesViewController.swift
//  Project Manager
//
//  Created by Student on 11/7/16.
//  Copyright © 2016 Hunter Pollpeter. All rights reserved.
//

import UIKit

class ProjectViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var project: Project!
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var deadlineLabel: UILabel!
    @IBOutlet weak var phasesView: UIView!
    
    override func viewDidLoad() {
        if let project = project {
            navigationItem.title = project.name
            let dateFormatter = NSDateFormatter()
            deadlineLabel.text = dateFormatter.stringFromDate(project.deadLine)
        }
        phasesView.layer.borderWidth = 1
        phasesView.layer.borderColor = UIColor.lightGrayColor().CGColor
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // MARK: - TableView Delegate
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PhaseTasks" {
            let tasksViewController = segue.destinationViewController as! TasksViewController
            let cell = sender as! UITableViewCell
            tasksViewController.phase = project.phases[tableView.indexPathForCell(cell)!.row]
        }
    }
    
    // MARK: - TableView DataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let project = project {
            return project.phases.count
        }
        return 0
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell", forIndexPath: indexPath)
        let phase = project.phases[indexPath.row]
        
        cell.textLabel?.text = phase.name
        cell.detailTextLabel?.text = "These are some details about this phase"
        
        return cell
    }
}
