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
    
    // MARK: - TableView Delegate
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case "PhaseTasks":
            let tasksViewController = segue.destinationViewController as! PhaseViewController
            let cell = sender as! UITableViewCell
            tasksViewController.phase = project.phases[tableView.indexPathForCell(cell)!.row]
        default:
            return
        }
    }

    
    // MARK: - TableView DataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        let contentView = header.contentView
        let button = UIButton(type: .Custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(button)
        let bottomConstraint = button.bottomAnchor.constraintEqualToAnchor(contentView.bottomAnchor)
        bottomConstraint.constant = 0
        let trailingConstraint = button.trailingAnchor.constraintEqualToAnchor(contentView.trailingAnchor)
        trailingConstraint.constant = -15
        bottomConstraint.active = true
        trailingConstraint.active = true
        switch section {
        case 0:
            button.setTitle("Edit", forState: .Normal)
            button.setTitleColor(UIColor.init(red: 0, green: 122, blue: 255, alpha: 1.0), forState: .Normal)
        default:
            return
        }
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
            default:
                detailText = String(value)
            }
            cell.detailTextLabel?.text = detailText
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("PercentCell", forIndexPath: indexPath)
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
}
