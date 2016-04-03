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

class ViewController: UIViewController {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var friendsButton: UIButton!
    @IBOutlet weak var meButton: UIButton!
    
   

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let pUserName = PFUser.currentUser()?["username"] as? String {
            self.usernameLabel.text = "Welcome @" + pUserName
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
