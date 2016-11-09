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
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            if let phase = phase {
                return phase.generalInformation.count
            }
        case 1:
            if let phase = phase {
                return phase.tasks.count
            }
        default:
            return 0
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("GeneralInformationCell", forIndexPath: indexPath)
            let information = phase.generalInformation[indexPath.row]
            cell.textLabel?.text = information.0
            cell.detailTextLabel?.text = information.1
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("PercentCell", forIndexPath: indexPath)
            let task = phase.tasks[indexPath.row]
            cell.textLabel?.text = task.name
            cell.detailTextLabel?.text = "These are some details about this phase"
//            let completionPercentLabel = UILabel(frame: CGRect())
//            completionPercentLabel.textAlignment = NSTextAlignment.Right
//            completionPercentLabel.text = "100%"
//            completionPercentLabel.sizeToFit()
//            completionPercentLabel.textColor = UIColor.lightGrayColor()
            if task.complete == true {
                cell.accessoryType = .Checkmark
            }

            return cell
        default:
            return UITableViewCell()
        }
        
    }
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "General Information"
        case 1:
            return "Tasks"
        default:
            return nil
        }
    }

}
