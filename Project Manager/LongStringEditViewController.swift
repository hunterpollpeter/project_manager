//
//  LongStringEditViewController.swift
//  Project Manager
//
//  Created by Student on 12/8/16.
//  Copyright © 2016 Hunter Pollpeter. All rights reserved.
//

import UIKit

class LongStringEditViewController: UIViewController {
    var sectionObject: SectionObject!
    var key: String!
    var index: Int?
    
    @IBOutlet var textView: UITextView!
    
    @IBAction func Done(sender: AnyObject) {
        var collection = sectionObject.properties[key] as! [String]
        if let index = index {
            collection[index] = textView.text
        }
        else {
            collection.append(textView.text)
        }
        sectionObject.properties.updateValue(collection, forKey: key)
        navigationController!.popViewControllerAnimated(true)
    }
    
    override func viewDidLoad() {
        let collection = sectionObject.properties[key] as! [String]
        if let index = index {
            navigationItem.title = "Edit"
            textView.text = collection[index]
        }
        else {
            navigationItem.title = "Create"
            textView.text = ""
        }
    }
}
