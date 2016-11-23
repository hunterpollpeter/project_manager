//
//  TaskViewController.swift
//  Project Manager
//
//  Created by Student on 11/10/16.
//  Copyright © 2016 Hunter Pollpeter. All rights reserved.
//

import UIKit

class TaskViewController: UITableViewController {
    var task: Task!
    
    let sections = ["Properties"]
    
    override func viewDidLoad() {
        if let task = task {
            let name = task.properties["Name"] as! String
            navigationItem.title = name
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
            if let task = task {
                return task.properties.count
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
            let key = Array(task.properties.keys)[indexPath.row]
            let value = task.properties[key]
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
        default:
            return UITableViewCell()
        }
    }

}
