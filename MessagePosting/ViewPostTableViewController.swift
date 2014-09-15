//
//  ViewPostTableViewController.swift
//  MessagePosting
//
//  Created by Nicolas Flacco on 8/23/14.
//  Copyright (c) 2014 Nicolas Flacco. All rights reserved.
//

import CoreData
import UIKit

class ViewPostTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
    var fetchedResultController: NSFetchedResultsController = NSFetchedResultsController()
    
    var post:Post? = nil
    
    let postViewCellIdentifier = "PostViewCell"
    let commentCellIdentifier = "CommentCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchedResultController = getFetchedResultController()
        fetchedResultController.delegate = self
        fetchedResultController.performFetch(nil)
        
        // i don't know why this weird .self construction is needed but it is
        tableView.estimatedRowHeight=44.0
        tableView.rowHeight=UITableViewAutomaticDimension
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: Selector("pullToRefresh"), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(self.refreshControl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        if let realPost:Post = post {
            MPComment.getCommentsForPost(realPost)
        }
    }

    // MARK: - Actions
    
    func pullToRefresh() {
        if let realPost:Post = post {
            println("Comment:PTR")
            MPComment.getCommentsForPost(realPost)
            self.refreshControl!.endRefreshing()
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 2
    }

    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        switch section {
        case 0:
            return 1
        default:
            if let realPost:Post = post {
                return fetchedResultController.sections[0].numberOfObjects
            } else {
                return 0
            }
        }
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        switch indexPath.section {
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier(commentCellIdentifier, forIndexPath: indexPath) as UITableViewCell

            // We have to modify our FetchedResultsController (see http://stackoverflow.com/questions/11540292/weird-behaviour-with-fetchedresultscontroller-in-numberofrowsinsection)
            let frcIndexPath = NSIndexPath(forRow: indexPath.row, inSection: indexPath.section - 1)
            let comment = fetchedResultController.objectAtIndexPath(frcIndexPath) as Comment
            cell.textLabel.text = comment.text
            return cell
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier(postViewCellIdentifier, forIndexPath: indexPath) as ViewPostTableViewCell
            if let realPost:Post = self.post {
                cell.postTextLabel.text = realPost.text
            }
            return cell
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if let realIdentifier:String = segue?.identifier {
            if realIdentifier == "comment" {
                let editPostVC = segue.destinationViewController as EditPostViewController
                editPostVC.post = self.post
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
        if let realPost:Post = self.post {
            let fetchRequest = NSFetchRequest(entityName: "Comment")
            let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: true)
            fetchRequest.predicate = NSPredicate(format: "post = %@", realPost)
            fetchRequest.sortDescriptors = [sortDescriptor]
            return fetchRequest
        } else {
            return NSFetchRequest(entityName: "")
        }
    }

}
