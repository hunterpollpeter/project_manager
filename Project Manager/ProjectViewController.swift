//
//  PhasesViewController.swift
//  Project Manager
//
//  Created by Student on 11/7/16.
//  Copyright © 2016 Hunter Pollpeter. All rights reserved.
//

import UIKit

class ProjectViewController: UITableViewController {
    var project: Project!
    let sections = ["General Information", "Phases"]
    
    override func viewDidLoad() {
        if let project = project {
            let name = project.properties["Name"] as! String
            navigationItem.title = name
        }
    }

    func prepareForUnwind() {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case "PhaseDetail":
            let tasksViewController = segue.destinationViewController as! PhaseViewController
            let cell = sender as! UITableViewCell
            tasksViewController.phase = project.phases[tableView.indexPathForCell(cell)!.row]
        case "EditProject":
            let navController = segue.destinationViewController as! UINavigationController
            let projectEditViewController = navController.topViewController as! ProjectCreateEditViewController
            projectEditViewController.project = project
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
            if let project = project {
                return project.properties.count
            }
        case 1:
            if let project = project {
                return project.phases.count
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
            let key = Array(project.properties.keys)[indexPath.row]
            let value = project.properties[key]
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
            case is [String]:
                let valueStringArray = value as! [String]
                detailText = String(valueStringArray.count)
                cell.accessoryType = .DisclosureIndicator
                cell.selectionStyle = .Default
            default:
                detailText = String(value)
            }
            cell.detailTextLabel?.text = detailText
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("DetailCell", forIndexPath: indexPath)
            let phase = project.phases[indexPath.row] 
            let name = phase.properties["Name"] as! String
            let details = phase.properties["Details"] as! String
            cell.textLabel?.text = name
            cell.detailTextLabel?.text = details

            return cell
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section != 0 {
            return
        }
        let key = Array(project.properties.keys)[indexPath.row]
        let value = project.properties[key]
        switch value {
        case is [String]:
            performSegueWithIdentifier("StringArray", sender: nil)
        default:
            return
        }
    }
}
