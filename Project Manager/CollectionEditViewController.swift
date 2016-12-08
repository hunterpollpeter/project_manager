//
//  CollectionEditViewController.swift
//  Project Manager
//
//  Created by Student on 12/8/16.
//  Copyright © 2016 Hunter Pollpeter. All rights reserved.
//

import UIKit

class CollectionEditViewController: UITableViewController {
    var sectionObject: SectionObject!
    var key: String!
    
    @IBAction func Add(sender: AnyObject) {
        performSegueWithIdentifier("EditLongString", sender: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationItem.title = key
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let collection = sectionObject.properties[key] as! [String]
        return collection.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let collection = sectionObject.properties[key] as! [String]
        let cell = tableView.dequeueReusableCellWithIdentifier("NoteCell", forIndexPath: indexPath)
        cell.textLabel?.text = collection[indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        switch editingStyle {
        case .Delete:
            var collection = sectionObject.properties[key] as! [String]
            collection.removeAtIndex(indexPath.row)
            sectionObject.properties[key] = collection
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        default:
            return
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case "EditLongString":
            let longStringEditViewController = segue.destinationViewController as! LongStringEditViewController
            longStringEditViewController.collection = sectionObject.properties[key] as! [String]
            longStringEditViewController.index = sender as? Int
        default:
            return
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("EditLongString", sender: indexPath.row)
    }
}
