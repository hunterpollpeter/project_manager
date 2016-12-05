//
//  StringEditViewController.swift
//  Project Manager
//
//  Created by Student on 12/5/16.
//  Copyright © 2016 Hunter Pollpeter. All rights reserved.
//

import UIKit

class StringEditViewController: UIViewController {
    
    var project: Project!
    var key: String!
    @IBOutlet var propertyNameLabel: UILabel!
    @IBOutlet var propertyValueTextField: UITextField!
    
    @IBAction func Done(sender: AnyObject) {
        project.properties[key] = propertyValueTextField.text!
        navigationController!.popViewControllerAnimated(true)
        let parentViewController = navigationController?.topViewController as! UITableViewController
        parentViewController.tableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        navigationItem.title = "Edit \(key)"
        propertyNameLabel.text = key
        propertyValueTextField.text = project.properties[key] as? String
    }
}
