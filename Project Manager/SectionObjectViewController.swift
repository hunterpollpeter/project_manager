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
    
    override func viewDidLoad() {
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(toggleCompleteLongPress))
        self.view.addGestureRecognizer(longPressRecognizer)
    }
    
    override func viewWillAppear(animated: Bool) {
        if let sectionObject = sectionObject {
            let name = sectionObject.properties["Name"] as! String
            navigationItem.title = name
        } else {
            Add.enabled = false
        }
        tableView.reloadData()
    }
    
    @IBOutlet var Add: UIBarButtonItem!
    
    @IBAction func Add(sender: AnyObject) {
        let sectionObjectType = sectionObject is Project ? "Phase" : "Task"
        let alertController = UIAlertController(title: "Create New", message: "Create a new Property or \(sectionObjectType).", preferredStyle: .ActionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let propertyAction = UIAlertAction(title: "Property", style: .Default, handler: { (action) -> Void in self.propertyAlertController()})
        alertController.addAction(propertyAction)
        
        let sectionObjectAction = UIAlertAction(title: sectionObjectType, style: .Default, handler: { (action) -> Void in self.performSegueWithIdentifier("Create\(sectionObjectType)", sender: nil) })
        alertController.addAction(sectionObjectAction)
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.barButtonItem = Add
        }
        
        self.presentViewController(alertController, animated: true, completion: nil)
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
        case "CreateCollection":
            let createCollectionViewController = segue.destinationViewController as! CreateCollectionViewController
            createCollectionViewController.sectionObject = sectionObject
        case "EditString":
            let stringEditViewController = segue.destinationViewController as! StringEditViewController
            stringEditViewController.sectionObject = sectionObject
            stringEditViewController.key = sender as? String
        case "EditDateTime":
            let dateTimeEditViewController = segue.destinationViewController as! DateTimeEditViewController
            dateTimeEditViewController.sectionObject = sectionObject
            dateTimeEditViewController.key = sender as? String
        case "EditCollection":
            let collectionEditViewController = segue.destinationViewController as! CollectionEditViewController
            collectionEditViewController.sectionObject = sectionObject
            collectionEditViewController.key = sender as? String
        case "EditCheck":
            let checkEditViewController = segue.destinationViewController as! CheckEditViewController
            checkEditViewController.sectionObject = sectionObject
            checkEditViewController.key = sender as? String
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
            case is Bool:
                let boolValue = value as! Bool
                cell.selectionStyle = .None
                if key == "Complete"{
                    if sectionObject is Task {
                        detailText = boolValue ? "" : "No"
                        cell.accessoryType =  boolValue ? .Checkmark : .None
                    }
                    else {
                        let numberFormatter = NSNumberFormatter()
                        numberFormatter.numberStyle = .PercentStyle
                        if let text = numberFormatter.stringFromNumber(sectionObject.percentComplete()) {
                            detailText = text == "NaN" ? "None" : text
                        }
                    }
                }
                else {
                    detailText = boolValue ? "" : "No"
                    cell.accessoryType =  boolValue ? .Checkmark : .None
                }
            case is NSDate:
                let dateValue = value as! NSDate
                detailText = dateFormatter.stringFromDate(dateValue)
            case is [String]:
                let valueStringArray = value as! [String]
                detailText = String(valueStringArray.count)
                cell.accessoryType = .DisclosureIndicator
            default:
                detailText = String(value)
            }
            cell.detailTextLabel?.text = detailText
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("DetailCell", forIndexPath: indexPath)
            let childSectionObject = sectionObject.childSections[indexPath.row]
            let name = childSectionObject.properties["Name"] as! String
            let details = childSectionObject.properties["Details"] as! String
            cell.textLabel?.text = name
            cell.detailTextLabel?.text = details
            if childSectionObject is Phase {
                let numberFormatter = NSNumberFormatter()
                numberFormatter.numberStyle = .PercentStyle
                let percentLabel = UILabel()
                if let text = numberFormatter.stringFromNumber(childSectionObject.percentComplete()) {
                    percentLabel.text = text == "NaN" ? "None" : text
                }
                percentLabel.textColor = UIColor(red: 145/255, green: 145/255, blue: 149/255, alpha: 1)
                percentLabel.sizeToFit()
                cell.accessoryView = percentLabel
            }
            else {
                if childSectionObject.properties["Complete"] as! Bool {
                    cell.accessoryType = .Checkmark
                } else {
                    cell.accessoryType = .None
                }
            }
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
        case is NSDate:
            performSegueWithIdentifier("EditDateTime", sender: key)
        case is Bool:
            if key == "Complete" {
                if sectionObject is Task {
                    sectionObject.toggleComplete()
                    tableView.reloadData()
                }
            }
            else {
                performSegueWithIdentifier("EditCheck", sender: key)
            }
        case is [String]:
            performSegueWithIdentifier("EditCollection", sender: key)
        default:
            return
        }
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        switch editingStyle {
        case .Delete:
            let sectionObjectType = sectionObject is Project ? "Phase" : "Task"
            let type = indexPath.section == 0 ? "Property" : sectionObjectType
            let alertController = UIAlertController(title: "Delete \(type)", message: "Are you sure you want to delete this \(type)?", preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: {(action) -> Void in
                if indexPath.section == 0 {
                    let key = Array(self.sectionObject.properties.keys)[indexPath.row]
                    self.sectionObject.removeObject(key)
                }
                else {
                    let childSectionObject = self.sectionObject.childSections[indexPath.row]
                    self.sectionObject.removeObject(childSectionObject)
                }
                tableView.reloadData()
            })
            alertController.addAction(deleteAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
        default:
            return
        }
    }
    
    func toggleCompleteLongPress(longPressRecognizer: UILongPressGestureRecognizer) {
        if !(sectionObject is Phase) {
            return
        }
        let touchPoint = longPressRecognizer.locationInView(view)
        if let indexPath = tableView.indexPathForRowAtPoint(touchPoint) {
            if indexPath.row < sectionObject.childSections.count {
                if let task = sectionObject.childSections[indexPath.row] as? Task {
                    if longPressRecognizer.state == .Began {
                        task.toggleComplete()
                        sectionObject.checkComplete()
                        tableView.reloadData()
                    }
                }
            }
        }
    }
    
    func propertyAlertController() {
        let alertController = UIAlertController(title: "New Property", message: "Create a new Property.", preferredStyle: .ActionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let textAction = UIAlertAction(title: "Text", style: .Default, handler: {(action) -> Void in
            self.performSegueWithIdentifier("EditString", sender: nil)
        })
        alertController.addAction(textAction)
        
        let collectionAction = UIAlertAction(title: "Collection", style: .Default, handler: {(action) -> Void in
            self.performSegueWithIdentifier("CreateCollection", sender: nil)
        })
        alertController.addAction(collectionAction)
        
        let checkAction = UIAlertAction(title: "Check", style: .Default, handler: {(action) -> Void in
            self.performSegueWithIdentifier("EditCheck", sender: nil)
        })
        alertController.addAction(checkAction)
        
        let dateAction = UIAlertAction(title: "Date", style: .Default, handler: {(action) -> Void in
            self.performSegueWithIdentifier("EditDateTime", sender: nil)
        })
        alertController.addAction(dateAction)
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.barButtonItem = Add
        }
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.section == 0 {
            let key = Array(sectionObject.properties.keys)[indexPath.row]
            if sectionObject.baseProperties.contains(key) {
                return false
            }
        }
        return true
    }
}
