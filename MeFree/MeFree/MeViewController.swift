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
    
    @IBOutlet weak var switchOutlet: UISwitch!
    @IBAction func switchTriggered(sender: AnyObject) {
        if switchOutlet.on {
            print("on")
            PFUser.currentUser()!["userStatus"] = "free"
            userStatusLabel.text = "free"
        } else {
            print("off")
            PFUser.currentUser()!["userStatus"] = "busy"
            userStatusLabel.text = "busy"
        }
        PFUser.currentUser()?.saveInBackground()
    }
  
    @IBAction func updateImageButton(sender: AnyObject) {
        
        var myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(myPickerController, animated: true, completion: nil)
        
    }
    
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        userImageLabel.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.dismissViewControllerAnimated(true, completion: nil)
        
        
        
        let imageData = UIImageJPEGRepresentation(userImageLabel.image!, 0.05)
        let imageFile = PFFile(name:"image.jpg", data:imageData!)
        do {
            let attempt = try imageFile!.save()
        } catch {
            print(error)
        }
        
        PFUser.currentUser()!["userPhoto"] = imageFile
        PFUser.currentUser()!.saveInBackground()
    }
 
    
    
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
        
        
        
        if let userPicture = PFUser.currentUser()?["userPhoto"] as? PFFile {
            userPicture.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                if (error == nil) {
                    self.userImageLabel.image = UIImage(data:imageData!)
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
