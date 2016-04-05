//
//  ProfileSettingsTableViewController.swift
//  MeFree
//
//  Created by Joshua Montgomery on 4/3/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class ProfileSettingsTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    var photoPickerFlag = false
    
    @IBOutlet weak var usernameText: UITextField!
 
    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var blurbText: UITextField!
    
    @IBOutlet weak var image: UIImageView!

    
    
    @IBAction func imageSelectClicked(sender: AnyObject) {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(myPickerController, animated: true, completion: nil)
    }
    
    @IBAction func saveInfo(sender: AnyObject) {
        
        let username = self.usernameText.text
        let email = self.emailText.text
        let blurb = self.blurbText.text
        
        if username?.characters.count < 5 || username?.characters.count > 25 {
            let alert = UIAlertView(title: "Invalid", message: "Username must be > 5 and < 25 characters", delegate: self, cancelButtonTitle: "OK")
            alert.show()
            
        } else if email?.characters.count < 8 || email? .characters.count > 40 {
            let alert = UIAlertView(title: "Invalid", message: "Please enter a valid email address", delegate: self, cancelButtonTitle: "OK")
            alert.show()
            
        } else if blurb?.characters.count > 100 {
            let alert = UIAlertView(title: "Invalid", message: "Please enter a blurb with 100 or less characters", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        } else {
            let spinner: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 150, 150)) as UIActivityIndicatorView
            spinner.startAnimating()
            
            let user = PFUser.currentUser()
            
            let imageData = UIImageJPEGRepresentation(image.image!, 0.05)
            let imageFile = PFFile(name:"image.jpg", data:imageData!)
            do {
                try imageFile!.save()
            } catch {
                print(error)
            }
            
            user?["userPhoto"] = imageFile
            user?.username = username
            user?.email = email
            user?["userBlurb"] = blurb
            
            user?.saveInBackgroundWithBlock({ (success, error) in
                spinner.stopAnimating()
                
                if success {
                    let alert = UIAlertView(title: "Success", message: "Profile info saved", delegate: self, cancelButtonTitle: "OK")
                    alert.show()
                }
            })
            

            
        }
        
        
        
        
        
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        print("didFinishpicking")
        image.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        image.clipsToBounds = true
        image.layer.borderWidth = 3.0
        image.layer.borderColor = UIColor.whiteColor().CGColor
        image.layer.cornerRadius = 10.0
        //self.tableView.reloadData()
        photoPickerFlag = true
        self.dismissViewControllerAnimated(true, completion: nil)
        
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.usernameText.delegate = self
        self.emailText.delegate = self
        self.blurbText.delegate = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        

        if photoPickerFlag == false {
            let user = PFUser.currentUser()
            self.usernameText.text = user?.username
            self.emailText.text = user?.email
            self.blurbText.text = user?["userBlurb"] as? String
            
            if let userPicture = user?["userPhoto"] as? PFFile {
                userPicture.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                    if (error == nil) {
                        self.image.image = UIImage(data:imageData!)
                        self.image.clipsToBounds = true
                        self.image.layer.borderWidth = 3.0
                        self.image.layer.borderColor = UIColor.whiteColor().CGColor
                        self.image.layer.cornerRadius = 10.0
                    }
                }
            }
            
        } else {
            photoPickerFlag = true
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    /*

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tableCell", forIndexPath: indexPath)

        cell.textLabel?.text = settings[indexPath.row]

        return cell
    }
    */
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
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
