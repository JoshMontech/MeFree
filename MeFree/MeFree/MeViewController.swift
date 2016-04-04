//
//  MeViewController.swift
//  MeFree
//
//  Created by Joshua Montgomery on 3/23/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class MeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //outlets
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var userStatusLabel: UILabel!
    @IBOutlet weak var userBlurbLabel: UILabel!
    @IBOutlet weak var userImageLabel: UIImageView!
    //@IBOutlet weak var switchOutlet: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let user = PFUser.currentUser()

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
        
        
        
        if let userPicture = PFUser.currentUser()?["userPhoto"] as? PFFile {
            userPicture.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                if (error == nil) {
                    self.userImageLabel.image = UIImage(data:imageData!)
                    self.userImageLabel.clipsToBounds = true
                    self.userImageLabel.layer.borderWidth = 3.0
                    self.userImageLabel.layer.borderColor = UIColor.whiteColor().CGColor
                    self.userImageLabel.layer.cornerRadius = 10.0
                }
            }
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
