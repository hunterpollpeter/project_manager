//
//  CheckEditViewController.swift
//  Project Manager
//
//  Created by Student on 12/10/16.
//  Copyright © 2016 Hunter Pollpeter. All rights reserved.
//

import UIKit

class CheckEditViewController: UIViewController {
    var sectionObject: SectionObject!
    var key: String?
    @IBOutlet var nameStackView: UIStackView!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var checkedSegment: UISegmentedControl!
    @IBAction func Done() {
        if let key = key {
            let checked = checkedSegment.selectedSegmentIndex == 0 ? false : true
            sectionObject.properties.updateValue(checked, forKey: key)
        }
        else {
            let alertController = UIAlertController(title: "Failed to create check", message: nil, preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "Okay", style: .Cancel, handler: nil))
            
            let name = nameTextField.text!
            
            if name.isEmpty {
                alertController.message = "Name cannot be empty."
            }
            
            if sectionObject.properties[name] != nil {
                alertController.message = "\(name) is already a property name."
            }
            
            if let _ = alertController.message {
                self.presentViewController(alertController, animated: true, completion: nil)
                return
            }
            
            let checked = checkedSegment.selectedSegmentIndex == 0 ? false : true
            sectionObject.properties.updateValue(checked, forKey: name)
        }
        navigationController!.popViewControllerAnimated(true)
    }
    
    override func viewDidLoad() {
        if let key = key {
            nameStackView.hidden = true
            navigationItem.title = "Edit \(key)"
            checkedSegment.selectedSegmentIndex = sectionObject.properties[key] as! Bool == false ? 0 : 1
        }
        else {
            navigationItem.title = "Create Check"
        }
    }
}
