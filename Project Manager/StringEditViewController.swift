//
//  StringEditViewController.swift
//  Project Manager
//
//  Created by Student on 12/5/16.
//  Copyright © 2016 Hunter Pollpeter. All rights reserved.
//

import UIKit

class StringEditViewController: UIViewController {
    
    var sectionObject: SectionObject!
    var key: String?
    
    @IBOutlet var propertyNameLabel: UILabel!
    @IBOutlet var propertyValueTextField: UITextField!
    @IBOutlet var nameStackView: UIStackView!
    @IBOutlet var nameTextField: UITextField!
    
    @IBAction func Done(sender: AnyObject) {
        if let key = key {
            let alertController = UIAlertController(title: "Failed to edit \(key)", message: nil, preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "Okay", style: .Cancel, handler: nil))
            
            let text = propertyValueTextField.text!
            
            if text.isEmpty {
                alertController.message = "Text cannot be empty."
            }
            
            if let _ = alertController.message {
                self.presentViewController(alertController, animated: true, completion: nil)
                return
            }
            
            sectionObject.properties.updateValue(propertyValueTextField.text! , forKey: key)
        }
        else {
            let alertController = UIAlertController(title: "Failed to edit \(key)", message: nil, preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "Okay", style: .Cancel, handler: nil))
            
            let name = nameTextField.text!
            
            if name.isEmpty {
                alertController.message = "Name cannot be empty."
            }
            
            if sectionObject.properties[name] != nil {
                alertController.message = "\(name) is already a property name."
            }
            
            let text = propertyValueTextField.text!
            
            if text.isEmpty {
                alertController.message = "Text cannot be empty."
            }
            
            if let _ = alertController.message {
                self.presentViewController(alertController, animated: true, completion: nil)
                return
            }
            
            sectionObject.properties.updateValue(propertyValueTextField.text! , forKey: name)
        }
        navigationController!.popViewControllerAnimated(true)
        let parentViewController = navigationController?.topViewController as! UITableViewController
        parentViewController.tableView.reloadData()
    }
    
    @IBAction func dismissKeyboard() {
        view.endEditing(false)
    }
    
    override func viewDidLoad() {
        if let key = key {
            nameStackView.hidden = true
            navigationItem.title = "Edit \(key)"
            propertyNameLabel.text = key
            propertyValueTextField.text = sectionObject.properties[key] as? String
        } else {
            navigationItem.title = "Create Text"
            propertyNameLabel.text = "Text"
        }
    }
}
