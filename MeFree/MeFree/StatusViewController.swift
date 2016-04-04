//
//  StatusViewController.swift
//  MeFree
//
//  Created by Joshua Montgomery on 3/29/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class StatusViewController: UIViewController {
    
    @IBOutlet weak var userStatusLabel: UILabel!
    @IBOutlet weak var switchOutlet: UISwitch!
    @IBAction func switchTriggered(sender: AnyObject) {
        
        if switchOutlet.on {
            freeTriggered()
        } else {
            busyTriggered()
        }
       
        
    }

    func backgroundColorChange(color: UIColor){
        UIView.animateWithDuration(0.5, delay: 0.0, options:UIViewAnimationOptions.TransitionFlipFromLeft, animations: {
            self.view.backgroundColor = color
        }, completion:nil)
    }
    
    func freeTriggered () {
        //debug - print("free triggered")
        PFUser.currentUser()!["userStatus"] = "free"
         PFUser.currentUser()?.saveInBackground()
        
        backgroundColorChange(UIColor.greenColor())
        userStatusLabel.text = "free"
    }
    
    func busyTriggered () {
        //debug - print("busy triggered")
        PFUser.currentUser()!["userStatus"] = "busy"
         PFUser.currentUser()?.saveInBackground()
        
        backgroundColorChange(UIColor.redColor())
        userStatusLabel.text = "busy"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //PFUser.currentUser()!["userStatus"] = "busy"
        //PFUser.currentUser()!.saveInBackground()
        // Do any additional setup after loading the view.
        if let userStatus = PFUser.currentUser()?["userStatus"] {
            userStatusLabel.text = userStatus as? String
            if userStatusLabel.text == "free" {
                switchOutlet.on = true
                view.backgroundColor = UIColor.greenColor()
            } else {
                switchOutlet.on = false
                view.backgroundColor = UIColor.redColor()
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
