//
//  CreateProjectViewController.swift
//  Project Manager
//
//  Created by Student on 11/15/16.
//  Copyright © 2016 Hunter Pollpeter. All rights reserved.
//

import UIKit

class ProjectCreateViewController: SectionObjectCreateViewController {
    
    var projectStore: ProjectStore!
    
    @IBAction override func Done() {
        let alertController = UIAlertController(title: "Failed to create project", message: nil, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "Okay", style: .Cancel, handler: { (_) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy h:m a"
        let name = nameTextField.text!
        let details = detailsTextField.text!
        let startDateString = startDateTextField.text!
        let startTimeString = startTimeTextField.text!
        let deadlineDateString = deadlineDateTextField.text!
        let deadlineTimeString = deadlineTimeTextField.text!
        let start = dateFormatter.dateFromString("\(startDateString) \(startTimeString)")
        let deadline = dateFormatter.dateFromString("\(deadlineDateString) \(deadlineTimeString)")
        
        if name.isEmpty {
            alertController.message = "Name field is empty."
        }
        else if details.isEmpty {
            alertController.message = "Details field is empty."
        }
        else if startDateString.isEmpty {
            alertController.message = "No start date set."
        }
        else if startTimeString.isEmpty {
            alertController.message = "No start time set."
        }
        else if deadlineDateString.isEmpty {
            alertController.message = "No deadline date set."
        }
        else if deadlineTimeString.isEmpty {
            alertController.message = "No deadline time set."
        }
        else if start == nil {
            alertController.message = "Start not in correct format."
        }
        else if deadline == nil {
            alertController.message = "Deadline not in correct format."
        }
        else if start!.laterDate(deadline!) == start {
            alertController.message = "Start date must be earlier than deadline."
        }

        if let _ = alertController.message {
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        }
        
        projectStore.createProject(name, details: details, start: start!, deadline: deadline!)
        
        if let parentNavController = self.parentViewController?.navigationController {
            parentNavController.popViewControllerAnimated(true)
            let projectsViewController = parentNavController.topViewController as! ProjectsViewController
            projectsViewController.tableView.reloadData()
//            let index = projectStore.allProjects.indexOf(project)!
//            let indexPath = NSIndexPath(forRow: index, inSection: 0)
//            projectsViewController.tableView.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: .None)
//            projectsViewController.tableView.cellForRowAtIndexPath(indexPath)?.setSelected(true, animated: true)
//            projectsViewController.performSegueWithIdentifier("ProjectDetail", sender: nil)
        }
        else {
            let parent = parentViewController as! UINavigationController
            let splitViewController = parent.parentViewController as! SplitViewController
            let navController = splitViewController.viewControllers[0] as! UINavigationController
            let projectsViewController =  navController.topViewController as! ProjectsViewController
            projectsViewController.tableView.reloadData()
//            let index = projectStore.allProjects.indexOf(project)!
//            let indexPath = NSIndexPath(forRow: index, inSection: 0)
//            projectsViewController.tableView.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: .None)
//            projectsViewController.tableView.cellForRowAtIndexPath(indexPath)?.setSelected(true, animated: true)
//            projectsViewController.performSegueWithIdentifier("ProjectDetail", sender: nil)
        }
    }
    
}
