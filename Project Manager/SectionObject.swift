//
//  SectionObject.swift
//  Project Manager
//
//  Created by Student on 12/5/16.
//  Copyright © 2016 Hunter Pollpeter. All rights reserved.
//

import Foundation

class SectionObject: NSObject {
    var tableSections = ["Properties"]
    var properties: [String: AnyObject]!
    var childSections: [SectionObject]!
}