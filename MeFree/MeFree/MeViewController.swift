//
//  MeViewController.swift
//  MeFree
//
//  Created by Joshua Montgomery on 3/23/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class MeViewController: UIViewController {
    
    //outlets
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var userStatusLabel: UILabel!
    @IBOutlet weak var userBlurbLabel: UILabel!
    
   // username.text = user?["username"]
   
    
    
    
 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var user = PFUser.currentUser()
        //user?["userBlurb"] = "I'm a cool college student"
        //user?.saveInBackground()
        if let userName = user!.username {
            userNameLabel.text = userName
        }
        
        if let userEmail = user!.email {
            userEmailLabel.text = userEmail
        }
        
        if let userStatus = user?["userStatus"] {
            userStatusLabel.text = userStatus as? String
        }
        
        if let userBlurb = user?["userBlurb"] {
            userBlurbLabel.text = userBlurb as? String
        }
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
