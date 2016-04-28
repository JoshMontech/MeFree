/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse

class ViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!

    @IBOutlet weak var usernamePhoto: UIImageView!
   
    @IBOutlet weak var homeSubview: UIView!

    @IBAction func buttonPressed(sender: AnyObject) {
       
        self.performSegueWithIdentifier("showView", sender: self)
        
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showView" {
            let vc = segue.destinationViewController
            if #available(iOS 8.0, *) {
                let controller = vc.popoverPresentationController
                if controller != nil {
                    controller?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
                    controller?.delegate = self
                    
                    let horizontalInset = (self.view.frame.size.width - 300) / 2.0
                    let verticalInset = (self.view.frame.size.height - 200) / 2.0
                    controller?.popoverLayoutMargins =
                        UIEdgeInsetsMake(
                            verticalInset,
                            horizontalInset,
                            verticalInset,
                            horizontalInset)
                    
                }
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    @available(iOS 8.0, *)
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.loadList(_:)),name:"load", object: nil)
        //statusButton.backgroundColor = UIColor.clearColor()
        statusButton.layer.cornerRadius = 10
        //statusButton.layer.borderWidth = 1
        //statusButton.layer.borderColor = UIColor.blackColor().CGColor
        
    }
    
    func loadList(notification: NSNotification){
        //load data here
        self.viewWillAppear(true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let pUserName = PFUser.currentUser()?["username"] as? String {
            self.usernameLabel.text = "Welcome @" + pUserName
        }
        
    
        if let userPicture = PFUser.currentUser()?["userPhoto"] as? PFFile {
            userPicture.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                if (error == nil) {
                    self.usernamePhoto.image = UIImage(data:imageData!)
                    self.usernamePhoto.clipsToBounds = true
                    self.usernamePhoto.layer.borderWidth = 6.0
                    if PFUser.currentUser()!["userStatus"] as? String == "free" {
                        //self.homeSubview.backgroundColor = UIColor(red: 34/255, green: 238/255, blue: 91/255, alpha: 1/3)
                        self.usernamePhoto.layer.borderColor = UIColor(colorLiteralRed: 8/255, green: 169/255, blue: 76/255, alpha: 1.0).CGColor
                    } else {
                        //self.homeSubview.backgroundColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1/3)
                        self.usernamePhoto.layer.borderColor = UIColor(colorLiteralRed: 198/255, green: 38/255, blue: 48/255, alpha: 1.0).CGColor
                        
                    }
                    //self.usernamePhoto.layer.borderColor = UIColor.whiteColor().CGColor
                    self.usernamePhoto.layer.cornerRadius = self.usernamePhoto.frame.size.width / 2
                }
            }
        }
        

        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if PFUser.currentUser() == nil || PFUser.currentUser()?.username == nil {
            PFUser.logOut()
            loginScreen()
        }
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginScreen() {
        performSegueWithIdentifier("login", sender: self)
        /*
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Login")
            self.presentViewController(viewController, animated: true, completion: nil)
        })
        */
    }
    
    @IBAction func logOutButton(sender: AnyObject) {
        // Send a request to log out a user
        PFUser.logOut()
        loginScreen()
        /*
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Login")
            self.presentViewController(viewController, animated: true, completion: nil)
        })
 */
    }
    
}
