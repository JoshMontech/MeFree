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
    
    var usernames = [""]
    var userids = [""]
    var friends = [""]
    //var reloadTimer = 0
    //var isFollowing = [Bool]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        var query = PFUser.query()
        query?.findObjectsInBackgroundWithBlock({ (objects, error) in
            
            if let users = objects {
                
                self.usernames.removeAll(keepCapacity: true)
                self.userids.removeAll(keepCapacity: true)
                self.friends.removeAll(keepCapacity: true)
                
                for object in users {
                    
                    if let user = object as? PFUser {
                        
                        if user.objectId != PFUser.currentUser()?.objectId {
                            
                            self.usernames.append(user.username!)
                            self.userids.append(user.objectId!)
                            
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
                                print(self.friends)
                                self.tableView.reloadData()
                            })
                        }
                    }
                }
                
            }

        })
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
        return  friends.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)

        // Configure the cell...
        cell.textLabel?.text = friends[indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        print(indexPath.row)
        var following = PFObject(className: "Followers")
        following["following"] = userids[indexPath.row]
        following["follower"] = PFUser.currentUser()?.objectId
        following.saveInBackground()
        
    }

}
