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
    @IBOutlet weak var userBlurbLabel: UILabel!
    @IBOutlet weak var userImageLabel: UIImageView!
    //@IBOutlet weak var switchOutlet: UISwitch!
    @IBOutlet weak var firstLastAge: UILabel!
    @IBOutlet weak var userStatus: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let user = PFUser.currentUser()

        if let userName = user!.username {
            userNameLabel.text = userName
        }
        
        var firstLastAgeString = ""
        if let firstName = user?["userFirstName"] as? String {
            firstLastAgeString += firstName
        }
        if let lastName = user?["userLastName"] as? String {
            firstLastAgeString += " " + lastName
        }
        if let age = user?["userAge"] as? String {
            firstLastAgeString += ", " + age
        }
        firstLastAge.text = firstLastAgeString
 
        if let status = user?["userStatusText"] as? String {
            userStatus.text = status
        }

        
        if let userBlurb = user?["userBlurb"] as? String {
            userBlurbLabel.text = userBlurb
        }
        
        
        
        if let userPicture = PFUser.currentUser()?["userPhoto"] as? PFFile {
            userPicture.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                if (error == nil) {
                    self.userImageLabel.image = UIImage(data:imageData!)
                    self.userImageLabel.clipsToBounds = true
                    self.userImageLabel.layer.borderWidth = 6.0
                    let status =  user?["userStatus"] as! String
                    if status == "free" {
                        self.userImageLabel.layer.borderColor = UIColor(colorLiteralRed: 8/255, green: 169/255, blue: 76/255, alpha: 1.0).CGColor
                        self.userStatus.textColor = UIColor(colorLiteralRed: 8/255, green: 169/255, blue: 76/255, alpha: 1.0)
                    } else {
                        self.userImageLabel.layer.borderColor = UIColor(colorLiteralRed: 198/255, green: 38/255, blue: 48/255, alpha: 1.0).CGColor
                        self.userStatus.textColor = UIColor(colorLiteralRed: 198/255, green: 38/255, blue: 48/255, alpha: 1.0)

                    }
                    //self.userImageLabel.layer.borderColor = UIColor.whiteColor().CGColor
                    self.userImageLabel.layer.cornerRadius = self.userImageLabel.frame.size.width / 2
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
