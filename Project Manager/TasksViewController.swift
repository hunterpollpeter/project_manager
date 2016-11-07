//
//  TasksViewController.swift
//  Project Manager
//
//  Created by Student on 11/7/16.
//  Copyright © 2016 Hunter Pollpeter. All rights reserved.
//

import UIKit

class TasksViewController: UITableViewController {
    var phase: Phase!
    
    override func viewDidLoad() {
        if let phase = phase {
            navigationItem.title = phase.name
        }
    }
    
    // MARK: - TableView DataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let phase = phase {
            return phase.tasks.count
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell", forIndexPath: indexPath)
        let task = phase.tasks[indexPath.row]
        
        cell.textLabel?.text = task.name
        cell.detailTextLabel?.text = "These are some details about this phase"
        
        return cell
    }

}
