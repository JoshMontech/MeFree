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
    
    var friendsOfUser = [PFUser]()


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
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! FriendTableViewCell

        let friend = friendsOfUser[indexPath.row]
        //var image : UIImage = UIImage(named: "red.jpg")!
        if let userPicture = friend["userPhoto"] as? PFFile {
            userPicture.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                if (error == nil) {
                    //cell.imageView!.frame = CGRectMake(0, 0, 10, 10)

                    cell.cellImage.image = UIImage(data:imageData!)
                    
                    cell.cellImage.layer.cornerRadius = cell.cellImage.frame.size.width / 2
                    cell.cellImage.clipsToBounds = true
                    cell.cellImage.layer.borderWidth = 1.0
                    cell.cellImage.layer.borderColor = UIColor.whiteColor().CGColor
                    
                }
            }
        }
        
        // Configure the cell...
        //cell.textLabel?.text = friend.username
        cell.cellUsername.text = friend.username
        cell.backgroundColor = UIColor(red: 255/255, green: 0, blue: 0, alpha: 1/3)
        //cell.backgroundColor?.colorWithAlphaComponent(1/2)
        //cell.backgroundColor = UIColor(red: 255/255, green: 205/255, blue: 204/255, alpha: 1/2)

        
        //if free, display green image
        if (friend["userStatus"] as? String == "free") {
            //image = UIImage(named: "green.jpg")!
            //cell.backgroundColor = UIColor(red: 217/255, green: 247/255, blue: 187/255, alpha: 1/2)
            cell.backgroundColor = UIColor(red: 34/255, green: 238/255, blue: 91/255, alpha: 1/3)
            //34, 238, 91
            //cell.alpha = 1/2

            
        //if busy display red image
        }
        
        //cell.imageView!.image = image
        

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let profileUser = self.friendsOfUser[indexPath.row]
        let profileViewController = self.storyboard?.instantiateViewControllerWithIdentifier("profile") as!ProfileViewController
        
        profileViewController.profileUser = profileUser
        self.navigationController?.pushViewController(profileViewController, animated: true)
        
    }

}
