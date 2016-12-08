//
//  LongStringEditViewController.swift
//  Project Manager
//
//  Created by Student on 12/8/16.
//  Copyright © 2016 Hunter Pollpeter. All rights reserved.
//

import UIKit

class LongStringEditViewController: UIViewController {
    var collection: [String]!
    var index: Int?
    
    @IBOutlet var textView: UITextView!
    
    @IBAction func Done(sender: AnyObject) {
        if let index = index {
            collection[index] = textView.text
        }
        else {
            collection.append(textView.text)
        }
        navigationController!.popViewControllerAnimated(true)
    }
    
    override func viewDidLoad() {
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
