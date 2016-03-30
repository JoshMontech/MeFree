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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        userName.text = profileUser!.username
        userEmail.text = profileUser!.email
        

        // Do any additional setup after loading the view.
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
