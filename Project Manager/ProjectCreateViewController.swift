//
//  CreateProjectViewController.swift
//  Project Manager
//
//  Created by Student on 11/15/16.
//  Copyright © 2016 Hunter Pollpeter. All rights reserved.
//

import UIKit

class ProjectCreateViewController: UIViewController {
    
    var projectStore: ProjectStore!
    
    override func viewDidLoad() {
        navigationItem.title = "Create Project"
    }
    
    @IBAction func Done(sender: AnyObject) {
        projectStore.createProject("Cool Project", details: "These are the project details", start: NSDate(), deadline: NSDate())
        self.parentViewController!.navigationController!.popViewControllerAnimated(true)
    }
}
