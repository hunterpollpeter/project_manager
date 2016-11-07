//
//  PhasesViewController.swift
//  Project Manager
//
//  Created by Student on 11/7/16.
//  Copyright © 2016 Hunter Pollpeter. All rights reserved.
//

import UIKit

class PhasesViewController: UITableViewController {
    var cell: UITableViewCell!
    
    override func viewDidLoad() {
        if let cell = cell {
            navigationItem.title = cell.textLabel?.text
        }
    }
}
