//
//  ProfileViewController.swift
//  MeFree
//
//  Created by Joshua Montgomery on 3/29/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var friendButtonText: UIButton!
    
    @IBAction func friendInvite(sender: AnyObject) {
        print(friendship)
        addOrRemoveFriend(friendship!)
        
    }
    
    var profileUser : PFUser?
    var friendship : Bool?
    //var friendshipObject : PFObject?
    

    override func viewDidLoad() {
        super.viewDidLoad()
 
        userName.text = profileUser!.username
        if let userPicture = profileUser?["userPhoto"] as? PFFile {
            userPicture.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                if (error == nil) {
                    self.userImage.image = UIImage(data:imageData!)
                }
            }
        }
        
        checkRecordFriendship()
        if friendship == true {
            //friend display
            
            userEmail.text = profileUser?.email
            friendButtonText.setTitle("Remove Friend", forState: .Normal)
            //userblurb
            //userphoto
            //sendrequest
            
            //display friend uninvite button
            
        } else {
            //not friend display
            
            userEmail.text = ""
            var query = PFQuery(className: "FriendRequests")
            query.whereKey("fromUser", equalTo: PFUser.currentUser()!)
            query.whereKey("toUser", equalTo: profileUser!)
            query.whereKey("requestStatus", equalTo: "requested")
            query.findObjectsInBackgroundWithBlock({ (objects, error) in
                if objects!.count == 0 {
                    self.friendButtonText.setTitle("Send Friend Request", forState: .Normal)
                } else {
                    self.friendButtonText.hidden = true
                }
            })
            
            //userphoto
            
        }
        
        
       
        


        // Do any additional setup after loading the view.
    }

    func addOrRemoveFriend (friendship: Bool) {
        if friendship == true {
            //remove friend
            //reload screen
            self.friendButtonText.hidden = true
            let userCheckOne = PFQuery(className: "Friendships")
            userCheckOne.whereKey("userB", equalTo: PFUser.currentUser()!)
            userCheckOne.whereKey("userA", equalTo: profileUser!)
            
            let userCheckTwo = PFQuery(className: "Friendships")
            userCheckTwo.whereKey("userA", equalTo: PFUser.currentUser()!)
            userCheckOne.whereKey("userB", equalTo: profileUser!)
            
            let userCheck = PFQuery.orQueryWithSubqueries([userCheckOne, userCheckTwo])
            userCheck.includeKey("userA")
            userCheck.includeKey("userB")
            
            userCheck.findObjectsInBackgroundWithBlock({ (objects, error) in
                if objects!.count > 0 {
                    for object in objects! {
                        
                        object.deleteInBackground()
                        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                        appDelegate.updateFriendList()

                    }
                }
            })
            /*
            let userCheckA = PFQuery(className: "FriendRequests")
            userCheckOne.whereKey("fromUser", equalTo: PFUser.currentUser()!)
            userCheckOne.whereKey("toUser", equalTo: profileUser!)
            
            let userCheckB = PFQuery(className: "FriendRequests")
            userCheckTwo.whereKey("toUser", equalTo: PFUser.currentUser()!)
            userCheckOne.whereKey("fromUser", equalTo: profileUser!)
            
            let userCheckX = PFQuery.orQueryWithSubqueries([userCheckOne, userCheckTwo])
            userCheck.includeKey("fromUser")
            userCheck.includeKey("toUser")
            
            userCheckX.findObjectsInBackgroundWithBlock({ (objects, error) in
                if objects!.count > 0 {
                    objects![0]["requestStatus"] = ""
                    objects![0].saveInBackground()
                }
            })
            */
            
            
        } else {
            print("friend request updated")
            var query = PFQuery(className: "FriendRequests")
            query.whereKey("fromUser", equalTo: PFUser.currentUser()!)
            query.whereKey("toUser", equalTo: profileUser!)
            query.whereKey("requestStatus", equalTo: "requested")
            query.findObjectsInBackgroundWithBlock { (objects, error) in
                if objects!.count == 0 {
                    var request = PFObject(className: "FriendRequests")
                    request["fromUser"] = PFUser.currentUser()
                    request["toUser"] = self.profileUser
                    request["requestStatus"] = "requested"
                    self.friendButtonText.hidden = true
                    request.saveInBackground()
                }
            }
        
        }
    }
    
    func checkRecordFriendship () {
        //print("friends received in profile view from app delegate\(friends)")
        //query to check if user and other user are friends
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.updateFriendList()
        let friends = appDelegate.returnFriends()
        print("returnFriends: \(friends)")
        if friends.count == 0 {
            friendship = false
        } else {
            for friend in friends {
                //print("nada")
                if friend.objectId! == profileUser?.objectId {
                    friendship = true
                    break
                } else {
                    friendship = false
                }
            }
        }
        
        print("Friendship checked is \(friendship)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
