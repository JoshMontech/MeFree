//
//  FriendsTableViewController.swift
//  MeFree
//
//  Created by Joshua Montgomery on 3/27/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class FriendsTableViewController: UITableViewController {
    
    //var usernames = [""]
    //var users = [PFObject]()
    var friendsOfUser = [PFUser]()
    //var userids = [""]
    //var friends = [""]
    //var reloadTimer = 0
    //var isFollowing = [Bool]()

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //self.tableView.reloadData()
        //print("FriendTableViewWillAppear")
        
        let userCheckOne = PFQuery(className: "Friendships")
        userCheckOne.whereKey("userB", equalTo: PFUser.currentUser()!)
        
        let userCheckTwo = PFQuery(className: "Friendships")
        userCheckTwo.whereKey("userA", equalTo: PFUser.currentUser()!)
        
        let userCheck = PFQuery.orQueryWithSubqueries([userCheckOne, userCheckTwo])
        userCheck.includeKey("userA")
        userCheck.includeKey("userB")
        userCheck.findObjectsInBackgroundWithBlock { (objects, error) in
            self.friendsOfUser.removeAll()
            
            
            for object in objects! {
                if var user = object["userA"] as? PFUser {
                    if user.objectId != PFUser.currentUser()?.objectId {
                        //debug - print("appendA")
                        self.friendsOfUser.append(user)
                    } else {
                        user = (object["userB"] as? PFUser)!
                        if user.objectId != PFUser.currentUser()?.objectId {
                            //debug - print("appendB")
                            self.friendsOfUser.append(user)
                        }
                    }
                }
            }
            //debug - print("friendsOfUser")
            //debug - print(self.friendsOfUser)
            self.tableView.reloadData()
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /*
        let userCheckOne = PFQuery(className: "Friendships")
        userCheckOne.whereKey("userB", equalTo: PFUser.currentUser()!)
        
        let userCheckTwo = PFQuery(className: "Friendships")
        userCheckTwo.whereKey("userA", equalTo: PFUser.currentUser()!)
        
        let userCheck = PFQuery.orQueryWithSubqueries([userCheckOne, userCheckTwo])
        userCheck.includeKey("userA")
        userCheck.includeKey("userB")
        userCheck.findObjectsInBackgroundWithBlock { (objects, error) in

    
            for object in objects! {
                if var user = object["userA"] as? PFUser {
                    if user.objectId != PFUser.currentUser()?.objectId {
                        print("appendA")
                        self.friendsOfUser.append(user)
                    } else {
                        user = (object["userB"] as? PFUser)!
                        if user.objectId != PFUser.currentUser()?.objectId {
                            print("appendB")
                            self.friendsOfUser.append(user)
                        }
                    }
                }
            }
            print("friendsOfUser")
            print(self.friendsOfUser)
            self.tableView.reloadData()
 
        }
         */

   
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #waring Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows

        return  friendsOfUser.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)

        let friend = friendsOfUser[indexPath.row]
        var image : UIImage = UIImage(named: "red.jpg")!
        // Configure the cell...
        cell.textLabel?.text = friend.username

        
        //if free, display green image
        if (friend["userStatus"] as? String == "free") {
            image = UIImage(named: "green.jpg")!
        //if busy display red image
        }
        
        cell.imageView!.image = image

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let profileUser = self.friendsOfUser[indexPath.row]
        let profileViewController = self.storyboard?.instantiateViewControllerWithIdentifier("profile") as!ProfileViewController
        
        profileViewController.profileUser = profileUser
        self.navigationController?.pushViewController(profileViewController, animated: true)
        
    }

}
