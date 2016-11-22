//
//  CreateProjectViewController.swift
//  Project Manager
//
//  Created by Student on 11/15/16.
//  Copyright © 2016 Hunter Pollpeter. All rights reserved.
//

import UIKit

class ProjectCreateViewController: UIViewController, UITextFieldDelegate {
    
    var projectStore: ProjectStore!
    
    @IBOutlet var startDateTextField: UITextField!
    @IBOutlet var startTimeTextField: UITextField!
    @IBOutlet var deadlineDateTextField: UITextField!
    @IBOutlet var deadlineTimeTextField: UITextField!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var detailsTextField: UITextField!
    
    var startDatePicker: UIDatePicker!
    var deadlineDatePicker: UIDatePicker!
    var startTimePicker: UIDatePicker!
    var deadlineTimePicker: UIDatePicker!
    
    override func viewDidLoad() {
        navigationItem.title = "Create Project"
        
        let date = NSDate()
        
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = .MediumStyle
        dateFormatter.timeStyle = .NoStyle
        
        let dateString = dateFormatter.stringFromDate(date)
        
        startDateTextField.text = dateString
        deadlineDateTextField.text = dateString
        
        dateFormatter.dateStyle = .NoStyle
        dateFormatter.timeStyle = .ShortStyle
        
        let timeString = dateFormatter.stringFromDate(date)
        
        startTimeTextField.text = timeString
        deadlineTimeTextField.text = timeString
        
        startDatePicker = UIDatePicker()
        startDatePicker.datePickerMode = UIDatePickerMode.Date
        startDatePicker.addTarget(self, action: #selector(datePickerValueChanged), forControlEvents: UIControlEvents.ValueChanged)
        
        deadlineDatePicker = UIDatePicker()
        deadlineDatePicker.datePickerMode = UIDatePickerMode.Date
        deadlineDatePicker.addTarget(self, action: #selector(datePickerValueChanged), forControlEvents: UIControlEvents.ValueChanged)
        
        startTimePicker = UIDatePicker()
        startTimePicker.datePickerMode = UIDatePickerMode.Time
        startTimePicker.addTarget(self, action: #selector(timePickerValueChanged), forControlEvents: UIControlEvents.ValueChanged)
        
        deadlineTimePicker = UIDatePicker()
        deadlineTimePicker.datePickerMode = UIDatePickerMode.Time
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
        
        deadlineDateTextField.inputView = deadlineDatePicker
        deadlineDateTextField.inputAccessoryView = toolBar
        
        deadlineTimeTextField.inputView = deadlineTimePicker
        deadlineTimeTextField.inputAccessoryView = toolBar
    }
    
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

        dismissKeybord()
    }
    
    @IBAction func dismissKeybord() {
        view.endEditing(false)
    }
    
    @IBAction func Done(sender: AnyObject) {
        let alertController = UIAlertController(title: "Failed to create project", message: nil, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
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
            presentViewController(alertController, animated: true, completion: nil)
            return
        }
        if details.isEmpty {
            alertController.message = "Details field is empty."
            presentViewController(alertController, animated: true, completion: nil)
            return
        }
        if startDateString.isEmpty {
            alertController.message = "No start date set."
            presentViewController(alertController, animated: true, completion: nil)
            return
        }
        if startTimeString.isEmpty {
            alertController.message = "No start time set."
            presentViewController(alertController, animated: true, completion: nil)
            return
        }
        if deadlineDateString.isEmpty {
            alertController.message = "No deadline date set."
            presentViewController(alertController, animated: true, completion: nil)
            return
        }
        if deadlineTimeString.isEmpty {
            alertController.message = "No deadline time set."
            presentViewController(alertController, animated: true, completion: nil)
            return
        }
        if start == nil {
            alertController.message = "Start not in correct format."
            presentViewController(alertController, animated: true, completion: nil)
            return
        }
        if deadline == nil {
            alertController.message = "Deadline not in correct format."
            presentViewController(alertController, animated: true, completion: nil)
            return
        }
        projectStore.createProject(name, details: details, start: start!, deadline: deadline!)
        self.parentViewController!.navigationController!.popViewControllerAnimated(true)
    }

}
