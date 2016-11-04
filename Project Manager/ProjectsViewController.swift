//
//  ViewController.swift
//  Project Manager
//
//  Created by Student on 11/3/16.
//  Copyright © 2016 Hunter Pollpeter. All rights reserved.
//

import UIKit

class ProjectsViewController: UITableViewController {
    var projectStore: ProjectStore!
    
    @IBAction func addNewProject(sender: AnyObject) {
        let newProject = projectStore.createProject()
        
        
        if let index = projectStore.allProjects.indexOf(newProject) {
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
    
    // MARK: - TableView Delegate
    
    /* Implemented this to create the edit button next to the delete button. */
    /* source: https://developer.apple.com/reference/uikit/uitableviewdelegate/1614956-tableview */
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        // Edit a project
        let editRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Edit", handler:{action, indexpath in
            let project = self.projectStore.allProjects[indexPath.row]
            self.performSegueWithIdentifier("EditProject", sender: project)
        })
        editRowAction.backgroundColor = UIColor.lightGrayColor()
        
        // Delete a project
        let deleteRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Destructive, title: "Delete", handler:{action, indexpath in
            let project = self.projectStore.allProjects[indexPath.row]
            
            let ac = UIAlertController(title: "Delete \(project.name)", message: "Are you sure you want to delete this project?", preferredStyle: .ActionSheet)
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            ac.addAction(cancelAction)
            let deleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: { (action) -> Void in
                self.projectStore.removeProject(project)
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            })
            ac.addAction(deleteAction)
            
            self.presentViewController(ac, animated: true, completion: nil)
        })
        
        return [deleteRowAction, editRowAction];
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EditProject" {
            let projectEditViewController = segue.destinationViewController as! ProjectEditViewController
            projectEditViewController.project = sender as! Project
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let project = projectStore.allProjects[indexPath.row]
        project.currentProject = !project.currentProject
        tableView.reloadData()
    }
    
    // MARK: - TableView DataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projectStore.allProjects.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell", forIndexPath: indexPath)
        let project = projectStore.allProjects[indexPath.row]
        
        cell.textLabel?.text = project.name
        cell.detailTextLabel?.text = "This are some details about this project"
        if project.currentProject == true {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }
        
        return cell
    }
    
    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        let longpress = UILongPressGestureRecognizer(target: self, action: #selector(ProjectsViewController.longPressGestureRecognized(_:)))
        tableView.addGestureRecognizer(longpress)
    }
    
    // MARK: - Move Project Code
    
    /* Implemented this to move a project without having to enable editing mode. */
    /* source: https://www.freshconsulting.com/create-drag-and-drop-uitableview-swift/ */
    func longPressGestureRecognized(gestureRecognizer: UIGestureRecognizer) {
        let longPress = gestureRecognizer as! UILongPressGestureRecognizer
        let state = longPress.state
        let locationInView = longPress.locationInView(tableView)
        let indexPath = tableView.indexPathForRowAtPoint(locationInView)
        
        struct My {
            static var cellSnapshot : UIView? = nil
        }
        struct Path {
            static var initialIndexPath : NSIndexPath? = nil
        }
        
        switch state {
        case UIGestureRecognizerState.Began:
            if indexPath != nil {
                Path.initialIndexPath = indexPath
                let cell = tableView.cellForRowAtIndexPath(indexPath!) as UITableViewCell!
                My.cellSnapshot  = snapshotOfCell(cell)
                var center = cell.center
                My.cellSnapshot!.center = center
                My.cellSnapshot!.alpha = 0.0
                tableView.addSubview(My.cellSnapshot!)
                
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    center.y = locationInView.y
                    My.cellSnapshot!.center = center
                    My.cellSnapshot!.transform = CGAffineTransformMakeScale(1.05, 1.05)
                    My.cellSnapshot!.alpha = 0.98
                    cell.alpha = 0.0
                    
                    }, completion: { (finished) -> Void in
                        if finished {
                            cell.hidden = true
                        }
                })
            }
        case UIGestureRecognizerState.Changed:
            var center = My.cellSnapshot!.center
            center.y = locationInView.y
            My.cellSnapshot!.center = center
            if ((indexPath != nil) && (indexPath != Path.initialIndexPath)) {
                projectStore.moveProjectAtIndex(Path.initialIndexPath!.row, toIndex: indexPath!.row)
                tableView.moveRowAtIndexPath(Path.initialIndexPath!, toIndexPath: indexPath!)
                Path.initialIndexPath = indexPath
            }
        default:
            let cell = tableView.cellForRowAtIndexPath(Path.initialIndexPath!) as UITableViewCell!
            cell.hidden = false
            cell.alpha = 0.0
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                My.cellSnapshot!.center = cell.center
                My.cellSnapshot!.transform = CGAffineTransformIdentity
                My.cellSnapshot!.alpha = 0.0
                cell.alpha = 1.0
                }, completion: { (finished) -> Void in
                    if finished {
                        Path.initialIndexPath = nil
                        My.cellSnapshot!.removeFromSuperview()
                        My.cellSnapshot = nil
                    }
            })
        }
    }
    
    func snapshotOfCell(inputView: UIView) -> UIView {
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
        inputView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext() as UIImage
        UIGraphicsEndImageContext()
        let cellSnapshot : UIView = UIImageView(image: image)
        cellSnapshot.layer.masksToBounds = false
        cellSnapshot.layer.cornerRadius = 0.0
        cellSnapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0)
        cellSnapshot.layer.shadowRadius = 5.0
        cellSnapshot.layer.shadowOpacity = 0.4
        return cellSnapshot
    }

}

