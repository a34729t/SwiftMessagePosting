//
//  PostsTableViewController.swift
//  MessagePosting
//
//  Created by Nicolas Flacco on 8/17/14.
//  Copyright (c) 2014 Nicolas Flacco. All rights reserved.
//

import CoreData
import UIKit

class PostsTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    let cellIdentifier = "PostCell"
    let dateFormatter = NSDateFormatter()
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
    var fetchedResultController: NSFetchedResultsController = NSFetchedResultsController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateFormat = "yyyy-MM-dd 'at' h:mm a" // superset of OP's format
        
        fetchedResultController = getFetchedResultController()
        fetchedResultController.delegate = self
        fetchedResultController.performFetch(nil)
        
        // i don't know why this weird .self construction is needed but it is
        tableView.registerClass(PostTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.estimatedRowHeight=44.0
        tableView.rowHeight=UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return fetchedResultController.sections.count
    }
    
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultController.sections[section].numberOfObjects
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell? {
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as PostTableViewCell
        let post = fetchedResultController.objectAtIndexPath(indexPath) as Post
        cell.cellLabel.text = post.text
        return cell
    }
    
    override func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        return false
    }
    
    override func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            let managedObject:NSManagedObject = fetchedResultController.objectAtIndexPath(indexPath) as NSManagedObject
            managedObjectContext?.deleteObject(managedObject)
            managedObjectContext?.save(nil)
        }
    }
    
    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!)  {
        let cell = tableView.cellForRowAtIndexPath(indexPath);
        self.performSegueWithIdentifier("select", sender: cell) // Can I do this with 'selection' segue instead?
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if let realIdentifier:String = segue?.identifier {
            if realIdentifier == "select" {
                let cell = sender as PostTableViewCell
                let indexPath = tableView.indexPathForCell(cell)
                let post = fetchedResultController.objectAtIndexPath(indexPath) as Post
                let viewPostVC = segue.destinationViewController as ViewPostViewController
                viewPostVC.post = post
            }
        }
    }
    

    // MARK: - Core Data Stuff
    
    func controllerDidChangeContent(controller: NSFetchedResultsController!) {
        tableView.reloadData()
    }
    
    func getFetchedResultController() -> NSFetchedResultsController {
        fetchedResultController = NSFetchedResultsController(fetchRequest: taskFetchRequest(), managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultController
    }
    
    func taskFetchRequest() -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "Post")
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }

}
