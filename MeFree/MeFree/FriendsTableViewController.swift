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
        print("FriendTableViewWillAppear")
        
        
        //query every time table appears
        //can be optimized by giving user abililty to refresh when table is updated
        /*
        var query = PFQuery(className: "Friendships")
        query.includeKey("userA")
        query.whereKey("UserB", equalTo: PFUser.currentUser()!)
        query.findObjectsInBackgroundWithBlock { (objects, error) in
            self.friendsOfUser.removeAll(keepCapacity: true)
            if objects != nil && error == nil {
                if let followers = objects {
                    for object in followers {
                        if let following = object as? PFObject {
                            self.friendsOfUser.append(following["following"] as! PFUser)
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
        */
        /*
        let userCheckOne = PFQuery(className: "Friendships")
        //userCheckOne.includeKey("userA")
        userCheckOne.whereKey("userB", equalTo: PFUser.currentUser()!)
        
        let userCheckTwo = PFQuery(className: "Friendships")
        //userCheckTwo.includeKey("userB")
        userCheckTwo.whereKey("userA", equalTo: PFUser.currentUser()!)
        
        let userCheck = PFQuery.orQueryWithSubqueries([userCheckOne, userCheckTwo])
        userCheck.includeKey("userA")
        userCheck.includeKey("userB")
        userCheck.findObjectsInBackgroundWithBlock { (objects, error) in
            
            print(objects)
            //print(objects[0]["userA"].username)
            //let obj = objects![0] as PFObject
            //print(obj["userB"].username)
            
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        /*
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
 
        */
        let userCheckOne = PFQuery(className: "Friendships")
        //userCheckOne.includeKey("userA")
        userCheckOne.whereKey("userB", equalTo: PFUser.currentUser()!)
        
        let userCheckTwo = PFQuery(className: "Friendships")
        //userCheckTwo.includeKey("userB")
        userCheckTwo.whereKey("userA", equalTo: PFUser.currentUser()!)
        
        let userCheck = PFQuery.orQueryWithSubqueries([userCheckOne, userCheckTwo])
        userCheck.includeKey("userA")
        userCheck.includeKey("userB")
        userCheck.findObjectsInBackgroundWithBlock { (objects, error) in
            
            print(objects)
            //print(objects[0]["userA"].username)
            //let obj = objects![0] as PFObject
            //print(obj["userB"].username)
            
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

        return  friendsOfUser.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)

        // Configure the cell...
        cell.textLabel?.text = friendsOfUser[indexPath.row].username
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let profileUser = self.friendsOfUser[indexPath.row]
        let profileViewController = self.storyboard?.instantiateViewControllerWithIdentifier("profile") as!ProfileViewController
        
        profileViewController.profileUser = profileUser
        self.navigationController?.pushViewController(profileViewController, animated: true)
        
    }

}
