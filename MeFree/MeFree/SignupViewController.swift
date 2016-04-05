//
//  SignupViewController.swift
//  MeFree
//
//  Created by Joshua Montgomery on 3/22/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class SignupViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var picPicked = false
    
    //outlets
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var pwConfirmTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailConfirmTextField: UITextField!
    @IBOutlet weak var prfilePhotoImageView: UIImageView!
    
    @IBAction func selectProfileImageButton(sender: AnyObject) {
        
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(myPickerController, animated: true, completion: nil)
        
    }
    
   func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        prfilePhotoImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        prfilePhotoImageView.clipsToBounds = true
        prfilePhotoImageView.layer.borderWidth = 3.0
        prfilePhotoImageView.layer.borderColor = UIColor.whiteColor().CGColor
        prfilePhotoImageView.layer.cornerRadius = 10.0
        picPicked = true
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func signUpAction(sender: AnyObject) {
        
        let username = self.usernameTextField.text
        let password = self.passwordTextField.text
        let pwConfirm = self.pwConfirmTextField.text
        let email = self.emailTextField.text
        let emailConfirm = self.emailConfirmTextField.text
        let finalEmail =  email!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        
        
        if username?.characters.count < 5 {
            let alert = UIAlertView(title: "Invalid", message: "Username must be greater than 5 characters", delegate: self, cancelButtonTitle: "OK")
            alert.show()
            
        } else if password?.characters.count < 8 {
            let alert = UIAlertView(title: "Invalid", message: "Password must be greater than 8 characters", delegate: self, cancelButtonTitle: "OK")
            alert.show()
            
        } else if password != pwConfirm {
            let alert = UIAlertView(title: "Invalid", message: "Passwords do not match", delegate: self, cancelButtonTitle: "OK")
            alert.show()
            
        } else if email != emailConfirm {
            let alert = UIAlertView(title: "Invalid", message: "Emails do not match", delegate: self, cancelButtonTitle: "OK")
            alert.show()
            
        } else if email?.characters.count < 8 {
            let alert = UIAlertView(title: "Invalid", message: "Please enter a valid email address", delegate: self, cancelButtonTitle: "OK")
            alert.show()
            
        } else if picPicked == false {
            let alert = UIAlertView(title: "Invalid", message: "Please select a profile image", delegate: self, cancelButtonTitle: "OK")
            alert.show()
            
        } else {
            // Run a spinner to show a task in progress
            let spinner: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 150, 150)) as UIActivityIndicatorView
            spinner.startAnimating()
            
            let newUser = PFUser()
            
            let imageData = UIImageJPEGRepresentation(prfilePhotoImageView.image!, 0.05)
            let imageFile = PFFile(name:"image.jpg", data:imageData!)
            do {
                try imageFile!.save()
            } catch {
                print(error)
            }
            
            newUser.username = username
            newUser.password = password
            newUser.email = finalEmail
            newUser["userPhoto"] = imageFile
            
            // Sign up the user asynchronously
            newUser.signUpInBackgroundWithBlock({ (succeed, error) -> Void in
                
                // Stop the spinner
                spinner.stopAnimating()
                if ((error) != nil) {
                    let alert = UIAlertView(title: "Error", message: "\(error)", delegate: self, cancelButtonTitle: "OK")
                    alert.show()
                    
                } else {
                    let alert = UIAlertView(title: "Success", message: "Signed Up", delegate: self, cancelButtonTitle: "OK")
                    alert.show()
                    self.presentingViewController!.presentingViewController!.dismissViewControllerAnimated(true, completion: nil)
                }
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignupViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        prfilePhotoImageView.clipsToBounds = true
        prfilePhotoImageView.layer.borderWidth = 3.0
        prfilePhotoImageView.layer.borderColor = UIColor.whiteColor().CGColor
        prfilePhotoImageView.layer.cornerRadius = 10.0
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func signupButton(sender: AnyObject) {
        signUpAction(self)
    }
    
    @IBAction func loginButton(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
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
