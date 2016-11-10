//
//  TaskViewController.swift
//  Project Manager
//
//  Created by Student on 11/10/16.
//  Copyright © 2016 Hunter Pollpeter. All rights reserved.
//

import UIKit

class TaskViewController: UIViewController {
    var task: Task!
    
    override func viewDidLoad() {
        if let task = task {
            let name = task.properties["Name"] as! String
            navigationItem.title = name
        }
    }
}
