//
//  CreateProjectViewController.swift
//  Project Manager
//
//  Created by Student on 11/15/16.
//  Copyright © 2016 Hunter Pollpeter. All rights reserved.
//

import UIKit

class CreateProjectViewController: UIViewController {
    
    var projectStore: ProjectStore!
    
    @IBAction func done(sender: AnyObject) {
        projectStore.createProject()
    }
}
