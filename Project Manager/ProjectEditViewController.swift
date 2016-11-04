//
//  ProjectEditViewController.swift
//  Project Manager
//
//  Created by Student on 11/3/16.
//  Copyright © 2016 Hunter Pollpeter. All rights reserved.
//

import UIKit

class ProjectEditViewController: UIViewController {
    
    var project: Project!
    
    override func viewDidLoad() {
        if let project = project {
            navigationItem.title = project.name
        }
    }
}