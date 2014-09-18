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
    
    let keyHasLaunchedOnce = "HasLaunchedOnce"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateFormat = "yyyy-MM-dd 'at' HH:mm"
        
        fetchedResultController = getFetchedResultController()
        fetchedResultController.delegate = self
        fetchedResultController.performFetch(nil)
        
        tableView.estimatedRowHeight=44.0
        tableView.rowHeight=UITableViewAutomaticDimension
        
        // Check if launched
        maybeDoNUX()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: Selector("pullToRefresh"), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(self.refreshControl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        MPPost.getPosts()
    }
    
    // MARK: - Actions
    
    func pullToRefresh() {
        println("Post:PTR")
        MPPost.getPosts()
        self.refreshControl!.endRefreshing()
    }
    
    // TODO: Menu
    

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
        cell.postTextLabel.text = post.text
        cell.dateLabel.text = dateFormatter.stringFromDate(post.createdAt)
        cell.commentCountLabel.text = "\(post.numberComments)"
        
        return cell
    }
    
    override func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        return false
    }
    
    // TODO: remove this?
    override func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            let managedObject:NSManagedObject = fetchedResultController.objectAtIndexPath(indexPath) as NSManagedObject
            managedObjectContext?.deleteObject(managedObject)
            managedObjectContext?.save(nil)
        }
    }
    
    // MARK: - NUX
    
    func maybeDoNUX() {
        if (!NSUserDefaults.standardUserDefaults().boolForKey(keyHasLaunchedOnce)) {
            self.performSegueWithIdentifier("NUX", sender: self)
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: keyHasLaunchedOnce)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if let realIdentifier:String = segue?.identifier {
            if realIdentifier == "select" {
                let cell = sender as PostTableViewCell
                let indexPath = tableView.indexPathForCell(cell)
                let post = fetchedResultController.objectAtIndexPath(indexPath) as Post
                MPComment.getCommentsForPost(post)
                
                let viewPostTVC = segue.destinationViewController as ViewPostTableViewController
                viewPostTVC.post = post
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
        let fetchRequest = NSFetchRequest(entityName: coreDataEntityPost)
        let sortDescriptor = NSSortDescriptor(key: "updatedAt", ascending: false) // TODO: We use chronological order for comments, but reverse-chronological for posts!
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }

}
