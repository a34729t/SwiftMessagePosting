//
//  PostDetailTableViewController.swift
//  MessagePosting
//
//  Created by Nicolas Flacco on 8/23/14.
//  Copyright (c) 2014 Nicolas Flacco. All rights reserved.
//

import CoreData
import UIKit

class PostDetailTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
    var fetchedResultController: NSFetchedResultsController = NSFetchedResultsController()
    
    var post:Post? = nil
    
    let postViewCellIdentifier = "PostViewCell"
    let commentCellIdentifier = "CommentCell"
    
    var gotoButton = UIButton()
    
    let minRowsToShowGotoButtons = 18
    
    let dateFormatter = NSDateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchedResultController = getFetchedResultController()
        fetchedResultController.delegate = self
        fetchedResultController.performFetch(nil)
        
        dateFormatter.dateFormat = "yyyy-MM-dd 'at' HH:mm"
        
        // i don't know why this weird .self construction is needed but it is
        tableView.estimatedRowHeight=44.0
        tableView.rowHeight=UITableViewAutomaticDimension
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.addTarget(self, action: Selector("pullToRefresh"), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(self.refreshControl!)
        
        // No empty cells at bottom
        self.tableView.tableFooterView = UIView()
        
        // Go to top/bottom button?
        self.maybeShowGotoButtons()
        self.gotoButton.addTarget(self, action: "gotoButtonPressed:", forControlEvents: .TouchUpInside)
    }
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
        
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.height
        let navBarHeight = self.navigationController!.navigationBar.frame.size.height
//        updateButton(self.goToTopButton, horizontalMargin: 0, verticalMargin: 20 + navBarHeight + statusBarHeight, top: true)
        updateButton(self.gotoButton, horizontalMargin: -10, verticalMargin: -30, top: false)
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.gotoButton.removeFromSuperview()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UIScrollView Delegates (enable/disable goto button for navigating posts with lots of comments)
    
    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        UIView.animateWithDuration(0.1, animations: {
            self.gotoButton.alpha = 0.5
        })
    }
    
    override func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        UIView.animateWithDuration(0.2, animations: {
            self.gotoButton.alpha = 1.0
            self.maybeShowGotoButtons()
        })
    }
    
    override func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        // This is used for the programmatic scroll top/bottom when clicking buttons
        self.maybeShowGotoButtons()
    }
    
    override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.maybeShowGotoButtons()
    }
    
    // MARK: - Actions
    
    func pullToRefresh() {
        if let realPost:Post = post {
            println("Comment:PTR")
            MPComment.getCommentsForPost(realPost)
            self.refreshControl!.endRefreshing()
        }
    }
    
    func gotoButtonPressed(sender: UIButton!) {
        if let realPost = post {
            if realPost.numberComments > 0 {
                if self.atBottom() {
                    let indexPath:NSIndexPath = NSIndexPath(forRow: 0, inSection: 0)
                    self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
                } else {
                    let indexPath:NSIndexPath = NSIndexPath(forRow: realPost.numberComments - 1, inSection: 1)
                    self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
                }
            }
        }
    }
    
    // MARK: - UI Helpers
    
    func updateButton(button: UIButton, horizontalMargin: CGFloat, verticalMargin: CGFloat, top: Bool) {
        // Add the button to the superview and position it on the right side, at top or bottom
        var superview = self.navigationController!.view
        
        superview.addSubview(button)
        button.setTranslatesAutoresizingMaskIntoConstraints(false)
        var viewsDict = Dictionary <String, UIView>()
        viewsDict["button"] = button
        
        let x = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.TrailingMargin, relatedBy: NSLayoutRelation.Equal, toItem: superview, attribute: NSLayoutAttribute.TrailingMargin, multiplier: 1, constant: horizontalMargin)
        
        var y:NSLayoutConstraint?
        if top {
            y = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.TopMargin, relatedBy: NSLayoutRelation.Equal, toItem: superview, attribute: NSLayoutAttribute.TopMargin, multiplier: 1, constant: verticalMargin)
        } else {
            y = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.BottomMargin, relatedBy: NSLayoutRelation.Equal, toItem: superview, attribute: NSLayoutAttribute.BottomMargin, multiplier: 1, constant: verticalMargin)
        }
        
        let size:CGFloat = 20
        let width = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: size)
        let height = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: size)
        
        superview.addConstraints([x, y!, width, height])
    }
    
    func maybeShowGotoButtons() {
        let yOffset:CGFloat = self.tableView.contentOffset.y
        
        if (self.post!.numberComments < minRowsToShowGotoButtons) {
            // Hide and disable buttons
            self.gotoButton.hidden = true
            self.gotoButton.enabled = false
        } else {
            // Show buttons, depending on content offset
            
            if self.atBottom() {
                self.gotoButton.setImage(UIImage(named: "gotoTopIcon"), forState: .Normal)
            } else {
                self.gotoButton.setImage(UIImage(named: "gotoBottomIcon"), forState: .Normal)
            }
            
            // And enable
            self.gotoButton.hidden = false
            self.gotoButton.enabled = true
        }
    }
    
    func atBottom() -> Bool {
        let height = self.tableView.contentSize.height - self.tableView.frame.size.height

        if self.tableView.contentOffset.y < 10 {
            //reach top
            return false
        }
        else if self.tableView.contentOffset.y < height/2.0 {
            // halfway?
            return false
        }
        else {
            return true
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        switch section {
        case 0:
            return 1
        default:
            if let realPost:Post = post {
                return fetchedResultController.sections![0].numberOfObjects
            } else {
                return 0
            }
        }
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 1:
            
            let separatorFrame = CGRectMake(0, 0, tableView.frame.width, 1);
            var view = UIView(frame: separatorFrame)
            view.backgroundColor = UIColor.blackColor()
            return view
        default:
            return UIView() // blank view
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
            case 1:
                return 1
            default:
                return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier(commentCellIdentifier, forIndexPath: indexPath) as PostDetailCommentTableViewCell

            // We have to modify our FetchedResultsController (see http://stackoverflow.com/questions/11540292/weird-behaviour-with-fetchedresultscontroller-in-numberofrowsinsection)
            let frcIndexPath = NSIndexPath(forRow: indexPath.row, inSection: indexPath.section - 1)
            let comment = fetchedResultController.objectAtIndexPath(frcIndexPath) as Comment
//            cell.textLabel?.text = comment.text
            
            cell.cellView.commentTextLabel.text = comment.text
            
            return cell
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier(postViewCellIdentifier, forIndexPath: indexPath) as PostDetailTableViewCell
            if let realPost:Post = self.post {
                cell.cellView.postTextLabel.text = realPost.text
                cell.cellView.dateLabel.text = dateFormatter.stringFromDate(realPost.createdAt)
            }
            return cell
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "comment" {
            let editPostVC = segue.destinationViewController as EditPostViewController
            editPostVC.post = self.post
        }
    }
    
    // MARK: - Core Data Stuff
    
    func controllerDidChangeContent(controller: NSFetchedResultsController!) {
        tableView.reloadData()
        self.maybeShowGotoButtons()
    }
    
    func getFetchedResultController() -> NSFetchedResultsController {
        fetchedResultController = NSFetchedResultsController(fetchRequest: taskFetchRequest(), managedObjectContext: managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
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
