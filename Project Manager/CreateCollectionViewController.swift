//
//  CreateCollectionViewController.swift
//  Project Manager
//
//  Created by Student on 12/10/16.
//  Copyright © 2016 Hunter Pollpeter. All rights reserved.
//

import UIKit

class CreateCollectionViewController: UIViewController {
    var sectionObject: SectionObject!
    @IBOutlet var nameTextField: UITextField!
    @IBAction func Done(sender: AnyObject) {
        let alertController = UIAlertController(title: "Failed to create collection", message: nil, preferredStyle: .Alert)
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
        let collection: [String] = []
        sectionObject.properties.updateValue(collection , forKey: name)
        
        navigationController!.popViewControllerAnimated(true)
    }
}
