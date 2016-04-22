//
//  FriendRequestTableViewController.swift
//  MeFree
//
//  Created by Joshua Montgomery on 3/30/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class FriendRequestTableViewController: UITableViewController {
    
    var friendRequests = [PFObject]()
    //let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
        //debug - print("friendRequestViewWillAppear")
    }
 

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        let query = PFQuery(className: "FriendRequests")
        query.includeKey("fromUser")
        query.whereKey("toUser", equalTo: PFUser.currentUser()!)
        query.whereKey("requestStatus", equalTo: "requested")
        query.findObjectsInBackgroundWithBlock { (objects, error) in
            // self.users.removeAll(keepCapacity: true)
            self.friendRequests.removeAll(keepCapacity: true)
            if objects != nil && error == nil {
               self.friendRequests = objects!
            }
            
            //print(self.userFollowing)
            //print(self.userFollowingArr[0].username)
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return friendRequests.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as!FriendRequestTableViewCell

        // Configure the cell...
        cell.nameLabel?.text = friendRequests[indexPath.row]["fromUser"].username
        
        cell.acceptButton.tag = indexPath.row
        cell.rejectButton.tag = indexPath.row
        
        cell.acceptButton.addTarget(self, action: #selector(FriendRequestTableViewController.acceptFriendRequest(_:)), forControlEvents: .TouchUpInside)
        
        cell.rejectButton.addTarget(self, action: #selector(FriendRequestTableViewController.rejectFriendRequest(_:)), forControlEvents: .TouchUpInside)
    
         //cell.titleLabel?.text = targetUser.username
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //update requestStatus
        //print("update requeststatus")
    }
    
    //updates friend status
    func updateStatus (request: PFObject, status: String) {
        request["requestStatus"] = status
        request.saveInBackground()
    }
    
    @IBAction func acceptFriendRequest(sender: UIButton) {
        //update DB
        
        //debug - print("Before accept: \(appDelegate.friendsOfUser)")
        //print("acceptFriendRequest")
        let userRelation = self.friendRequests[sender.tag]
        //print(self.friendRequests[sender.tag])
        updateStatus(userRelation, status: "confirmed")
        
        
        let createFriendship = PFObject(className: "Friendships")
        createFriendship["userA"] = PFUser.currentUser()
        createFriendship["userB"] = userRelation["fromUser"]
        /*
        do {
            try createFriendship.save()
        } catch {
            error
        }
        */
        createFriendship.saveInBackgroundWithBlock { (status, error) in
            if status == true {
                self.friendRequests.removeAtIndex(sender.tag)
                self.tableView.reloadData()
            } else {
                print(error)
            }
        }
        
        
        //self.friendRequests.removeAtIndex(sender.tag)
        //self.tableView.reloadData()
        //appDelegate.updateFriendList()
        //debug - print("After accept: \(appDelegate.friendsOfUser)")
        //message prompt
        
        
    }
    
    @IBAction func rejectFriendRequest(sender: UIButton) {
        //not implemented yet
        //update DB
        updateStatus(self.friendRequests[sender.tag], status: "")
        self.friendRequests.removeAtIndex(sender.tag)
        self.tableView.reloadData()
        
        //message prompt
    }
 
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
