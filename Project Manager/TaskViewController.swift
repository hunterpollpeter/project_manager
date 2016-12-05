//
//  TaskViewController.swift
//  Project Manager
//
//  Created by Student on 11/10/16.
//  Copyright © 2016 Hunter Pollpeter. All rights reserved.
//

import UIKit

class TaskViewController: UITableViewController {
    var sectionObject: SectionObject!
    
    let sections = ["Properties"]
    
    override func viewWillAppear(animated: Bool) {
        if let sectionObject = sectionObject {
            let name = sectionObject.properties["Name"] as! String
            navigationItem.title = name
        }
        tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case "EditString":
            let stringEditViewController = segue.destinationViewController as! StringEditViewController
            stringEditViewController.sectionObject = sectionObject
            stringEditViewController.key = sender as! String
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
            if let sectionObject = sectionObject {
                return sectionObject.properties.count
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
            let key = Array(sectionObject.properties.keys)[indexPath.row]
            let value = sectionObject.properties[key]
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section != 0 {
            return
        }
        let key = Array(sectionObject.properties.keys)[indexPath.row]
        let value = sectionObject.properties[key]
        switch value {
        case is String:
            performSegueWithIdentifier("EditString", sender: key)
        default:
            return
        }
    }
}
