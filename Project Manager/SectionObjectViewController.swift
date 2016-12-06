//
//  PhasesViewController.swift
//  Project Manager
//
//  Created by Student on 11/7/16.
//  Copyright © 2016 Hunter Pollpeter. All rights reserved.
//

import UIKit

class SectionObjectViewController: UITableViewController {
    var sectionObject: SectionObject!
    
    override func viewWillAppear(animated: Bool) {
        if let sectionObject = sectionObject {
            let name = sectionObject.properties["Name"] as! String
            navigationItem.title = name
        }
        tableView.reloadData()
    }
    
    @IBOutlet var Add: UIBarButtonItem!
    
    @IBAction func Add(sender: AnyObject) {
        let sectionObjectType = sectionObject is Project ? "Phase" : "Task"
        let alertController = UIAlertController(title: "Create New", message: "Create a new Property or \(sectionObjectType).", preferredStyle: .ActionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let propertyAction = UIAlertAction(title: "Property", style: .Default, handler: nil)
        alertController.addAction(propertyAction)
        
        let sectionObjectAction = UIAlertAction(title: sectionObjectType, style: .Default, handler: { (action) -> Void in self.performSegueWithIdentifier("Create\(sectionObjectType)", sender: nil) })
        alertController.addAction(sectionObjectAction)
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.barButtonItem = Add
        }
        
        if let _ = alertController.message {
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        }

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case "PhaseDetail":
            let phaseViewController = segue.destinationViewController as! SectionObjectViewController
            let cell = sender as! UITableViewCell
            phaseViewController.sectionObject = sectionObject.childSections[tableView.indexPathForCell(cell)!.row]
        case "TaskDetail":
            let taskViewController = segue.destinationViewController as! SectionObjectViewController
            let cell = sender as! UITableViewCell
            taskViewController.sectionObject = sectionObject.childSections[tableView.indexPathForCell(cell)!.row]
        case "CreatePhase":
            let phaseCreateViewController = segue.destinationViewController as! SectionObjectCreateViewController
            phaseCreateViewController.sectionObject = sectionObject
        case "CreateTask":
            let taskCreateViewController = segue.destinationViewController as! SectionObjectCreateViewController
            taskCreateViewController.sectionObject = sectionObject
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
        if let sectionObject = sectionObject {
            return sectionObject.tableSections.count
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let sectionObject = sectionObject {
            return sectionObject.tableSections[section]
        }
        return nil
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            if let sectionObject = sectionObject {
                return sectionObject.properties.count
            }
        case 1:
            if let sectionObject = sectionObject {
                return sectionObject.childSections.count
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
                df.dateStyle = .MediumStyle
                df.timeStyle = .ShortStyle
                return df
            }()
            var detailText = ""
            cell.textLabel?.text = key
            switch value {
            case is String:
                let stringValue = value as! String
                detailText = stringValue
                cell.tag = 0
            case is Bool:
                let boolValue = value as! Bool
                detailText = boolValue ? "Yes" : "No"
                cell.tag = 1
            case is NSDate:
                let dateValue = value as! NSDate
                detailText = dateFormatter.stringFromDate(dateValue)
                cell.tag = 2
            case is [String]:
                let valueStringArray = value as! [String]
                detailText = String(valueStringArray.count)
                cell.accessoryType = .DisclosureIndicator
                cell.tag = 3
            default:
                detailText = String(value)
            }
            cell.detailTextLabel?.text = detailText
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("DetailCell", forIndexPath: indexPath)
            let phase = sectionObject.childSections[indexPath.row]
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
