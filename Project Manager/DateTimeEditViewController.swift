//
//  DateTimeEditViewController.swift
//  Project Manager
//
//  Created by Student on 12/6/16.
//  Copyright © 2016 Hunter Pollpeter. All rights reserved.
//

import UIKit

class DateTimeEditViewController: UIViewController, UITextFieldDelegate {
    var sectionObject: SectionObject!
    var key: String?
    
    var propertyDatePicker: UIDatePicker!
    var propertyTimePicker: UIDatePicker!
    
    @IBOutlet var propertyNameLabel: UILabel!
    @IBOutlet var propertyDateTextField: UITextField!
    @IBOutlet var propertyTimeTextField: UITextField!
    @IBOutlet var nameStackView: UIStackView!
    @IBOutlet var nameTextField: UITextField!
    
    @IBAction func Done(sender: AnyObject) {
        if let key = key {
            let sectionObjectParentType = sectionObject is Phase ? "Project" : sectionObject is Task ? "Phase" : "Parent"
            
            let alertController = UIAlertController(title: "Failed to edit \(key)", message: nil, preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "Okay", style: .Cancel, handler: nil))
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MMM d, yyyy h:m a"

            let propertyDateString = propertyDateTextField.text!
            let propertyTimeString = propertyTimeTextField.text!
            let newDate = dateFormatter.dateFromString("\(propertyDateString) \(propertyTimeString)")
            
            if newDate == nil {
                alertController.message = "\(key) not in correct format."
            }
            else if key == "Start" || key == "Deadline" {
                if let parent = sectionObject.parent {
                    let parentStart = parent.properties["Start"] as! NSDate
                    let parentDeadline = parent.properties["Deadline"] as! NSDate
                    if parentStart.earlierDate(newDate!) == newDate {
                        alertController.message = "\(key) cannot be before \(sectionObjectParentType) start."
                    }
                    else if parentDeadline.laterDate(newDate!) == newDate {
                        alertController.message = "\(key) cannot be after \(sectionObjectParentType) deadline."
                    }
                }
                let sectionObjectStart = sectionObject.properties["Start"] as! NSDate
                let sectionObjectDeadline = sectionObject.properties["Deadline"] as! NSDate
                if key == "Start" && sectionObjectDeadline.laterDate(newDate!) == newDate {
                    alertController.message = "Start date cannot be after deadline."
                }
                else if key == "Deadline" && sectionObjectStart.earlierDate(newDate!) == newDate {
                    alertController.message = "Deadline cannot be before start date."
                }
            }
            
            if let _ = alertController.message {
                self.presentViewController(alertController, animated: true, completion: nil)
                return
            }

            sectionObject.properties.updateValue(newDate!, forKey: key)
        }
        else {
            let alertController = UIAlertController(title: "Failed to create Date", message: nil, preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "Okay", style: .Cancel, handler: nil))
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MMM d, yyyy h:m a"
            
            let propertyDateString = propertyDateTextField.text!
            let propertyTimeString = propertyTimeTextField.text!
            let newDate = dateFormatter.dateFromString("\(propertyDateString) \(propertyTimeString)")
            
            let name = nameTextField.text!
            
            if name.isEmpty {
                alertController.message = "Name cannot be empty."
            }
            
            if sectionObject.properties[name] != nil {
                alertController.message = "\(name) is already a property name."
            }
            
            if newDate == nil {
                alertController.message = "Date not in correct format."
            }
            
            if let _ = alertController.message {
                self.presentViewController(alertController, animated: true, completion: nil)
                return
            }
            
            sectionObject.properties.updateValue(newDate!, forKey: name)
        }
        
        navigationController!.popViewControllerAnimated(true)
        let parentViewController = navigationController?.topViewController as! UITableViewController
        parentViewController.tableView.reloadData()
    }
    
    @IBAction func dismissKeyboard() {
        view.endEditing(false)
    }
    
    override func viewDidLoad() {
        propertyDatePicker = UIDatePicker()
        propertyDatePicker.datePickerMode = UIDatePickerMode.Date
        propertyDatePicker.addTarget(self, action: #selector(datePickerValueChanged), forControlEvents: UIControlEvents.ValueChanged)
        
        propertyTimePicker = UIDatePicker()
        propertyTimePicker.datePickerMode = UIDatePickerMode.Time
        propertyTimePicker.minuteInterval = 15
        propertyTimePicker.addTarget(self, action: #selector(timePickerValueChanged), forControlEvents: UIControlEvents.ValueChanged)
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .Done, target: nil, action: nil)
        doneButton.style = .Done
        doneButton.action = #selector(responderDoneButtonClicked)
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .Default
        toolBar.setItems([flexSpace ,doneButton], animated: true)
        toolBar.sizeToFit()
        
        propertyDateTextField.inputView = propertyDatePicker
        propertyDateTextField.inputAccessoryView = toolBar
        propertyDateTextField.delegate = self
        
        propertyTimeTextField.inputView = propertyTimePicker
        propertyTimeTextField.inputAccessoryView = toolBar
        propertyTimeTextField.delegate = self
        
        if let key = key  {
            nameStackView.hidden = true
            navigationItem.title = "Edit \(key)"
            propertyNameLabel.text = key
            let value = sectionObject.properties[key] as? NSDate
            let dateFormatter = NSDateFormatter()
    
            dateFormatter.dateStyle = .MediumStyle
            dateFormatter.timeStyle = .NoStyle
            propertyDateTextField.text = dateFormatter.stringFromDate(value!)
            
            dateFormatter.dateStyle = .NoStyle
            dateFormatter.timeStyle = .ShortStyle
            propertyTimeTextField.text = dateFormatter.stringFromDate(value!)
        }
        else {
            navigationItem.title = "Create Date"
            propertyNameLabel.text = "Date"
        }
    }
    
    // MARK: TextField Delegates
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let dateFormatter = NSDateFormatter()
        let currentString = textField.text!
        switch textField {
        case propertyDateTextField:
            dateFormatter.dateFormat = "MMM d, yyyy"
        case propertyTimeTextField:
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
    
    // MARK: Functions
    
    func datePickerValueChanged(sender: UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        dateFormatter.timeStyle = .NoStyle
        let text = dateFormatter.stringFromDate(sender.date)
        propertyDateTextField.text = text
    }
    
    func timePickerValueChanged(sender: UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .NoStyle
        dateFormatter.timeStyle = .ShortStyle
        let text = dateFormatter.stringFromDate(sender.date)
        propertyTimeTextField.text = text
    }
    
    func responderDoneButtonClicked(sender: AnyObject) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        dateFormatter.timeStyle = .NoStyle
        if propertyDateTextField.isFirstResponder() {
            propertyDateTextField.text = dateFormatter.stringFromDate(propertyDatePicker.date)
        }
        dateFormatter.dateStyle = .NoStyle
        dateFormatter.timeStyle = .ShortStyle
        if propertyTimeTextField.isFirstResponder() {
            propertyTimeTextField.text = dateFormatter.stringFromDate(propertyTimePicker.date)
        }
        
        dismissKeyboard()
    }
}

