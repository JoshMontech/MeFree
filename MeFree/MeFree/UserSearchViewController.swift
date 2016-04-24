//
//  UserSearchViewController.swift
//  MeFree
//
//  Created by Joshua Montgomery on 3/28/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class UserSearchViewController: UIViewController, UITableViewDelegate, UISearchBarDelegate, UITableViewDataSource {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    //search
    var searchActive : Bool = false
    var data:[PFUser]!
    var filtered:[PFObject]!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        search()
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func search(searchText: String? = nil){
        let finalTxt = searchText?.lowercaseString
        let query = PFUser.query()
        
        if(finalTxt != nil){
            query?.whereKey("username", containsString: finalTxt)
        }
        
        query?.findObjectsInBackgroundWithBlock { (results, error) -> Void in
            self.data = results as? [PFUser]!
            //remove PFUser.currentUser from table display
            var count = 0
            for user in self.data {
                //debug - print("loop")
                if user.objectId == PFUser.currentUser()?.objectId {
                    self.data.removeAtIndex(count)
                }
                count = count+1
            }
            
            //debug - print(self.data)
            self.tableView.reloadData()
        }
        
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //might create issues limiting to 20... note
        if self.data != nil {
            if self.data.count <= 20 {
                return self.data.count
            } else {
                return 20
            }
        } //else
        return 0
        //return self.users.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell

        //if self.data != nil || self.data.count > 0 {
            let obj = self.data[indexPath.row]
            cell.textLabel!.text = obj["username"] as? String
            return cell
        //}
        

        
        
        //return cell

    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //debug - print("You selected cell #\(indexPath.row)!")
        
        let profileUser = self.data[indexPath.row]
        print(profileUser)
        
        
        //if friend, profile view
        let profileViewController = self.storyboard?.instantiateViewControllerWithIdentifier("profile") as!ProfileViewController
        
        //if not friend, spectate view

        profileViewController.profileUser = profileUser
        self.navigationController?.pushViewController(profileViewController, animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        search(searchText)
    }

}
