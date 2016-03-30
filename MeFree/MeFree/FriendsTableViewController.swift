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
    var userFollowingArr = [PFUser]()
    //var userids = [""]
    //var friends = [""]
    //var reloadTimer = 0
    //var isFollowing = [Bool]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        var query = PFQuery(className: "Followers")
        query.includeKey("following")
        query.whereKey("follower", equalTo: PFUser.currentUser()!)
        query.findObjectsInBackgroundWithBlock { (objects, error) in
           // self.users.removeAll(keepCapacity: true)
            self.userFollowingArr.removeAll(keepCapacity: true)
            if objects != nil && error == nil {
                print("success")
                if let followers = objects {
                    for object in followers {
                        if let following = object as? PFObject {
                            self.userFollowingArr.append(following["following"] as! PFUser)
                            
                            
                            
                        }
                    }
                }
            }
            
            //print(self.userFollowing)
            //print(self.userFollowingArr[0].username)
            self.tableView.reloadData()
            //print(self.users)
            //print(self.users[0].valueForKey("follower")?.valueForKey("objectId"))
        }
 
        
    /*
        
        var query = PFUser.query()
        query?.findObjectsInBackgroundWithBlock({ (objects, error) in
            
            if let users = objects {
                
                self.usernames.removeAll(keepCapacity: true)
                self.users.removeAll(keepCapacity: true)
                self.userids.removeAll(keepCapacity: true)
                self.friends.removeAll(keepCapacity: true)
         
                for object in users {
                    
                    if let user = object as? PFUser {
                        
                        if user.objectId != PFUser.currentUser()?.objectId {
                            self.users.append(user)
                            self.usernames.append(user.username!)
                            self.userids.append(user.objectId!)
                            /*
                            //creates query finding who user follows
                            var query = PFQuery(className: "Followers")
                            query.whereKey("follower", equalTo: PFUser.currentUser()!.objectId!)
                            query.whereKey("following", equalTo: user.objectId!)
                       
                            query.findObjectsInBackgroundWithBlock({ (objects, error) in
                                if let friends = objects {
                                    for object in friends {
                                        if let friend = object as? PFObject {
                                            self.friends.append(user.username!)
                                            
                                        }
                                    }
                                }
                                //print(self.friends)
                                //self.tableView.reloadData()
                            })
                             */
                        }
                    }
                }
                
            }
            //print(self.friends)
            self.tableView.reloadData()

        })
        */
        
        //print(self.friends)
        //self.tableView.reloadData()
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

        return  userFollowingArr.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)

        // Configure the cell...
        cell.textLabel?.text = userFollowingArr[indexPath.row].username
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let profileUser = self.userFollowingArr[indexPath.row]
        let profileViewController = self.storyboard?.instantiateViewControllerWithIdentifier("profile") as!ProfileViewController
        
        profileViewController.profileUser = profileUser
        self.navigationController?.pushViewController(profileViewController, animated: true)
        
    }

}
