//
//  CreateProjectViewController.swift
//  Project Manager
//
//  Created by Student on 11/15/16.
//  Copyright © 2016 Hunter Pollpeter. All rights reserved.
//

import UIKit

class ProjectCreateEditViewController: UIViewController {
    
    var project: Project?
    
    override func viewDidLoad() {
        if let _ = project {
            navigationItem.title = "Edit Project"
        } else {
            navigationItem.title = "Create Project"
            project = Project()
        }
        let stackView = UIStackView()
        stackView.axis = .Vertical
        for property in project!.properties {
            let propertyView = UIStackView()
            propertyView.axis = .Horizontal
            let label = UILabel()
            label.text = property.0
            label.sizeToFit()
            label.setContentCompressionResistancePriority(751, forAxis: .Horizontal)
            let textField = UITextField()
//            textField.setContentCompressionResistancePriority(749, forAxis: .Horizontal)
            textField.text = property.1 as? String
            propertyView.addArrangedSubview(label)
            propertyView.addArrangedSubview(textField)
            stackView.addArrangedSubview(propertyView)
        }
        view = stackView
    }
}
