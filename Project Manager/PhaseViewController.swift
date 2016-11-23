//
//  TasksViewController.swift
//  Project Manager
//
//  Created by Student on 11/7/16.
//  Copyright © 2016 Hunter Pollpeter. All rights reserved.
//

import UIKit

class PhaseViewController: UITableViewController {
    var phase: Phase!
    let sections = ["Properties", "Tasks"]
    
    override func viewDidLoad() {
        if let phase = phase {
            let name = phase.properties["Name"] as! String
            navigationItem.title = name
        }
    }
    
    @IBOutlet var Add: UIBarButtonItem!
    
    @IBAction func Add(sender: AnyObject) {
        let alertController = UIAlertController(title: "Create New", message: "Create a new Property or Phase.", preferredStyle: .ActionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let propertyAction = UIAlertAction(title: "Property", style: .Default, handler: nil)
        alertController.addAction(propertyAction)
        
        let phaseAction = UIAlertAction(title: "Task", style: .Default, handler: { (action) -> Void in self.performSegueWithIdentifier("CreateTask", sender: nil) })
        alertController.addAction(phaseAction)
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.barButtonItem = Add
        }
        
        if let _ = alertController.message {
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        }
        
    }

    
    // MARK: - TableView Delegate
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case "TaskDetail":
            let taskViewController = segue.destinationViewController as! TaskViewController
            let cell = sender as! UITableViewCell
            taskViewController.task = phase.tasks[tableView.indexPathForCell(cell)!.row]
        case "CreateTask":
            let taskCreateViewController = segue.destinationViewController as! TaskCreateViewController
            taskCreateViewController.phase = phase
        default:
            return
        }
    }
    
    // MARK: - TableView DataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            if let phase = phase {
                return phase.properties.count
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
            let key = Array(phase.properties.keys)[indexPath.row]
            let value = phase.properties[key]
            let dateFormatter: NSDateFormatter = {
                let df = NSDateFormatter()
                df.dateStyle = NSDateFormatterStyle.MediumStyle
                return df
            }()
            var detailText = ""
            cell.textLabel?.text = key
            switch value {
            case is String:
                let stringValue = value as! String
                detailText = stringValue
            case is Bool:
                let boolValue = value as! Bool
                detailText = boolValue ? "Yes" : "No"
            case is NSDate:
                let dateValue = value as! NSDate
                detailText = dateFormatter.stringFromDate(dateValue)
            default:
                detailText = String(value)
            }
            cell.detailTextLabel?.text = detailText
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("PercentCell", forIndexPath: indexPath)
            let task = phase.tasks[indexPath.row]
            let name = task.properties["Name"] as! String
            let details = task.properties["Details"] as! String
            cell.textLabel?.text = name
            cell.detailTextLabel?.text = details
            return cell
        default:
            return UITableViewCell()
        }
    }
}
