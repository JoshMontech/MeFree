//
//  PopoverStatusViewController.swift
//  MeFree
//
//  Created by Joshua Montgomery on 4/23/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class PopoverStatusViewController: UIViewController {

    @IBOutlet weak var statusText: UITextField!
    @IBOutlet weak var statusSwitch: UISwitch!
    var status = true
    
    @IBAction func switchTriggered(sender: AnyObject) {
        if statusSwitch.on {
            freeTriggered()
        } else {
            busyTriggered()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let frameSize = CGPointMake(UIScreen.mainScreen().bounds.size.width*0.5, UIScreen.mainScreen().bounds.size.height*0.5)
        self.preferredContentSize = CGSizeMake(frameSize.x,frameSize.y)
        self.preferredContentSize = CGSizeMake(320.0, 360.0)
        
        // Do any additional setup after loading the view.
        if let userStatus = PFUser.currentUser()?["userStatus"] {
            
            if userStatus as! String == "free" {
                statusSwitch.on = true
                status = true
                view.backgroundColor = UIColor(colorLiteralRed: 8/255, green: 169/255, blue: 76/255, alpha: 1/2)
            } else {
                status = false
                statusSwitch.on = false
                view.backgroundColor = UIColor(colorLiteralRed: 198/255, green: 38/255, blue: 48/255, alpha: 1/2)
            }
        }
    }
    
    func backgroundColorChange(color: UIColor){
        UIView.animateWithDuration(0.5, delay: 0.0, options:UIViewAnimationOptions.TransitionFlipFromLeft, animations: {
            self.view.backgroundColor = color
            }, completion:nil)
    }
    
    func freeTriggered () {
        //debug - print("free triggered")
        status = true
        //PFUser.currentUser()!["userStatus"] = "free"
        //PFUser.currentUser()?.saveInBackground()
        
        backgroundColorChange(UIColor(red: 8/255, green: 169/255, blue: 76/255, alpha: 1/2))
    }
    
    func busyTriggered () {
        //debug - print("busy triggered")
        status = false
        //PFUser.currentUser()!["userStatus"] = "busy"
        //PFUser.currentUser()?.saveInBackground()
        
        backgroundColorChange(UIColor(red: 198/255, green: 38/255, blue: 48/255, alpha: 1/2))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func dismiss(sender: AnyObject) {
        
        if statusText != "" {
            PFUser.currentUser()!["userStatusText"] = statusText.text
        }
        
        if status == true {
            PFUser.currentUser()!["userStatus"] = "free"
        } else {
            PFUser.currentUser()!["userStatus"] = "busy"
        }
        
        PFUser.currentUser()?.saveInBackgroundWithBlock({ (bool, error) in
            if bool {
                NSNotificationCenter.defaultCenter().postNotificationName("load", object: nil)
                self.dismissViewControllerAnimated(true, completion: nil)
            } else {
                print(error)
            }
        })
        
        
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
