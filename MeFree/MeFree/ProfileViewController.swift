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
    
    var profileUser : PFUser?
    var userRelation : PFObject?
    var isRelation : Bool?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var request = PFObject(className: "FriendRequests")
        request.setObject(PFUser.currentUser()!, forKey: "fromUser")
        request.setObject(profileUser!, forKey: "toUser")
        request.setObject("requested", forKey: "requestStatus")
        request.saveInBackground()
        
        
        
        userName.text = profileUser!.username
        
        //query to check if user and other user are friends
        //print("derp")
        var query = PFQuery(className: "FriendRequests")
        query.whereKey("fromUser", equalTo: PFUser.currentUser()!)
        query.whereKey("toUser", equalTo: profileUser!)
        query.findObjectsInBackgroundWithBlock { (object, error) in
         
            if object != nil && error == nil {
                if object!.count > 0 {
                    self.userRelation = object![0]
                    if self.userRelation!["requestStatus"] as! String == "confirmed" {
                        self.userEmail.text = self.profileUser!.email
                    } else if self.userRelation!["requestStatus"] as! String == "rejected" {
                        self.userEmail.text = "rejected"
                    } else {
                        self.userEmail.text = "requested"
                    }
                } else {
                    self.userEmail.text = "Not friends"
                }
            }
        }
    
        
        //userEmail.text = profileUser!.email
       
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    override func viewWillAppear(animated: Bool) {
        <#code#>
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
