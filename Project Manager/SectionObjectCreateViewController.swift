//
//  PhaseCreateViewController.swift
//  Project Manager
//
//  Created by Student on 11/18/16.
//  Copyright © 2016 Hunter Pollpeter. All rights reserved.
//

import UIKit

class SectionObjectCreateViewController: UIViewController, UITextFieldDelegate {
    
    var sectionObject: SectionObject!
    var projectStore: ProjectStore?
    
    var startDatePicker: UIDatePicker!
    var deadlineDatePicker: UIDatePicker!
    var startTimePicker: UIDatePicker!
    var deadlineTimePicker: UIDatePicker!
    
    // MARK: Connections
    
    @IBOutlet var startDateTextField: UITextField!
    @IBOutlet var startTimeTextField: UITextField!
    @IBOutlet var deadlineDateTextField: UITextField!
    @IBOutlet var deadlineTimeTextField: UITextField!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var detailsTextField: UITextField!
    
    @IBAction func dismissKeyboard() {
        view.endEditing(false)
    }
    
    @IBAction func Done() {
        
        let sectionObjectType = sectionObject is Project ? "Phase" : sectionObject is Phase ? "Task" : "Project"
        let sectionObjectParentType = sectionObject is Project ? "Project" : "Phase"
        
        navigationItem.title = "Create \(sectionObjectType)"
        
        let alertController = UIAlertController(title: "Failed to create \(sectionObjectType)", message: nil, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "Okay", style: .Cancel, handler: nil))
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
        else if let sectionObject = sectionObject {
            let parentStart = sectionObject.properties["Start"] as! NSDate
            let parentDeadline = sectionObject.properties["Deadline"] as! NSDate
            
            if start!.earlierDate(parentStart) == start {
                alertController.message = "Start date cannot be before \(sectionObjectParentType) start date."
            }
            
            if deadline!.laterDate(parentDeadline) == deadline {
                alertController.message = "Deadline cannot be after \(sectionObjectParentType) deadline."
            }
        }
        
        if let _ = alertController.message {
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        }
        
        var childSectionObject: SectionObject!
        if sectionObject is Project {
            childSectionObject = Phase(name: name, details: details, start: start!, deadline: deadline!)
        }
        else if sectionObject is Phase {
            childSectionObject = Task(name: name, details: details, start: start!, deadline: deadline!)
        }
        else if let projectStore = projectStore {
            let project = projectStore.createProject(name, details: details, start: start!, deadline: deadline!)
            
            // Device does NOT support SplitViewController
            if let parentNavController = self.parentViewController?.navigationController {
                parentNavController.popViewControllerAnimated(true)
                let projectsViewController = parentNavController.topViewController as! ProjectsViewController
                projectsViewController.tableView.reloadData()
            }
            // Device does support SplitViewController
            else {
                let parent = parentViewController as! UINavigationController
                let splitViewController = parent.parentViewController as! SplitViewController
                let navController = splitViewController.viewControllers[0] as! UINavigationController
                let projectsViewController =  navController.topViewController as! ProjectsViewController
                projectsViewController.tableView.reloadData()
                let index = projectStore.allProjects.indexOf(project)!
                let indexPath = NSIndexPath(forRow: index, inSection: 0)
                projectsViewController.tableView.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: .None)
                projectsViewController.tableView.cellForRowAtIndexPath(indexPath)?.setSelected(true, animated: true)
                projectsViewController.performSegueWithIdentifier("ProjectDetail", sender: nil)
            }
            // Exit function
            return
        }
        
        sectionObject.childSections.append(childSectionObject)

        navigationController!.popViewControllerAnimated(true)
        let projectViewController = navigationController?.topViewController as! SectionObjectViewController
        projectViewController.tableView.reloadData()
    }
    
    // MARK: TextField Delegates
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let dateFormatter = NSDateFormatter()
        let currentString = textField.text!
        switch textField {
        case startDateTextField, deadlineDateTextField:
            dateFormatter.dateFormat = "MMM d, yyyy"
        case startTimeTextField, deadlineTimeTextField:
            dateFormatter.dateFormat = "h:m a"
        default:
            return true
        }
        if let _ = dateFormatter.dateFromString(currentString + string) {
            return true
        }
        return false
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        dismissKeyboard()
        return true
    }
    
    // MARK: ViewController Lifecycle
    
    override func viewDidLoad() {
        let sectionObjectType = sectionObject is Project ? "Phase" : sectionObject is Phase ? "Task" : "Project"
        navigationItem.title = "Create \(sectionObjectType)"
        
        nameTextField.delegate = self
        detailsTextField.delegate = self
        
        startDatePicker = UIDatePicker()
        startDatePicker.datePickerMode = UIDatePickerMode.Date
        startDatePicker.addTarget(self, action: #selector(datePickerValueChanged), forControlEvents: UIControlEvents.ValueChanged)
        
        deadlineDatePicker = UIDatePicker()
        deadlineDatePicker.datePickerMode = UIDatePickerMode.Date
        deadlineDatePicker.addTarget(self, action: #selector(datePickerValueChanged), forControlEvents: UIControlEvents.ValueChanged)
        
        startTimePicker = UIDatePicker()
        startTimePicker.datePickerMode = UIDatePickerMode.Time
        startTimePicker.minuteInterval = 15
        startTimePicker.addTarget(self, action: #selector(timePickerValueChanged), forControlEvents: UIControlEvents.ValueChanged)
        
        deadlineTimePicker = UIDatePicker()
        deadlineTimePicker.datePickerMode = UIDatePickerMode.Time
        deadlineTimePicker.minuteInterval = 15
        deadlineTimePicker.addTarget(self, action: #selector(timePickerValueChanged), forControlEvents: UIControlEvents.ValueChanged)
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .Done, target: nil, action: nil)
        doneButton.style = .Done
        doneButton.action = #selector(responderDoneButtonClicked)
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .Default
        toolBar.setItems([flexSpace ,doneButton], animated: true)
        toolBar.sizeToFit()
        
        startDateTextField.inputView = startDatePicker
        startDateTextField.inputAccessoryView = toolBar
        startDateTextField.delegate = self
        
        startTimeTextField.inputView = startTimePicker
        startTimeTextField.inputAccessoryView = toolBar
        startTimeTextField.delegate = self
        
        deadlineDateTextField.inputView = deadlineDatePicker
        deadlineDateTextField.inputAccessoryView = toolBar
        deadlineDateTextField.delegate = self
        
        deadlineTimeTextField.inputView = deadlineTimePicker
        deadlineTimeTextField.inputAccessoryView = toolBar
        deadlineTimeTextField.delegate = self
    }
    
    // MARK: Functions
    
    func datePickerValueChanged(sender: UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        dateFormatter.timeStyle = .NoStyle
        let text = dateFormatter.stringFromDate(sender.date)
        switch sender {
        case startDatePicker:
            startDateTextField.text = text
        case deadlineDatePicker:
            deadlineDateTextField.text = text
        default:
            return
        }
        
    }
    
    func timePickerValueChanged(sender: UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .NoStyle
        dateFormatter.timeStyle = .ShortStyle
        let text = dateFormatter.stringFromDate(sender.date)
        switch sender {
        case startTimePicker:
            startTimeTextField.text = text
        case deadlineTimePicker:
            deadlineTimeTextField.text = text
        default:
            return
        }
    }
    
    func responderDoneButtonClicked(sender: AnyObject) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        dateFormatter.timeStyle = .NoStyle
        if startDateTextField.isFirstResponder() {
            startDateTextField.text = dateFormatter.stringFromDate(startDatePicker.date)
        }
        if deadlineDateTextField.isFirstResponder() {
            deadlineDateTextField.text = dateFormatter.stringFromDate(deadlineDatePicker.date)
        }
        dateFormatter.dateStyle = .NoStyle
        dateFormatter.timeStyle = .ShortStyle
        if startTimeTextField.isFirstResponder() {
            startTimeTextField.text = dateFormatter.stringFromDate(startTimePicker.date)
        }
        if deadlineTimeTextField.isFirstResponder() {
            deadlineTimeTextField.text = dateFormatter.stringFromDate(deadlineTimePicker.date)
        }
        
        dismissKeyboard()
    }
}