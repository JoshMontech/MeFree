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
        tableView.tableFooterView = UIView(frame: CGRect.zero)
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
        let request = friendRequests[indexPath.row]
        let fromUser = request.objectForKey("fromUser")
        cell.nameLabel?.text = fromUser!.username
        
        //
        if let userPicture = fromUser?.objectForKey("userPhoto") as? PFFile {
            userPicture.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                if (error == nil) {
                    //cell.imageView!.frame = CGRectMake(0, 0, 10, 10)
                    
                    cell.cellImage.image = UIImage(data:imageData!)
                    
                    cell.cellImage.layer.cornerRadius = cell.cellImage.frame.size.width / 2
                    cell.cellImage.clipsToBounds = true
                    cell.cellImage.layer.borderWidth = 2.0
                    //cell.cellImage.layer.borderColor = UIColor.whiteColor().CGColor
                    if (fromUser?.objectForKey("userStatus") as? String == "free") {
                        //image = UIImage(named: "green.jpg")!
                        //cell.backgroundColor = UIColor(red: 217/255, green: 247/255, blue: 187/255, alpha: 1/2)
                        cell.cellImage.layer.borderColor = UIColor(colorLiteralRed: 8/255, green: 169/255, blue: 76/255, alpha: 1.0).CGColor
                        //34, 238, 91
                        //cell.alpha = 1/2
                        
                        
                        //if busy display red image
                    } else {
                        cell.cellImage.layer.borderColor = UIColor(colorLiteralRed: 198/255, green: 38/255, blue: 48/255, alpha: 1.0).CGColor
                    }
                    
                }
            }
        }

        //
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
