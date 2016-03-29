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
    //var items: [String] = ["We", "Heart", "Swift"]
    //var users = [PFUser]()
    //var isFollowing = [false]
    //search
    var searchActive : Bool = false
    var data:[PFUser]!
    var filtered:[PFObject]!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        

        /*
        
        //self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        // Do any additional setup after loading the view.
        //query db for all users
        var query = PFUser.query()
        query?.findObjectsInBackgroundWithBlock({ (objects, error) in
            self.users.removeAll(keepCapacity: true)
            self.isFollowing.removeAll(keepCapacity: true)
            if error == nil && objects != nil {
                for object in objects! {
                    if let user = object as? PFUser {
                        if user.objectId != PFUser.currentUser()?.objectId {
                            self.users.append(user)
                            
                            //followers
                            var query = PFQuery(className: "Followers")
                            
                            query.whereKey("follower", equalTo: PFUser.currentUser()!)
                            query.whereKey("following", equalTo: user)
                            
                            query.findObjectsInBackgroundWithBlock({ (objects, error) in
                                if let objects = objects {
                                    if objects.count > 0 {
                                        
                                        self.isFollowing.append(true)

                                    } else {
                                        
                                        self.isFollowing.append(false)
                                    }
                                  
                                }
                                
                                if self.isFollowing.count == self.users.count {
                                    self.tableView.reloadData()
                                }

                            })
                            
                        }
                    }
                }
            }
            //print(self.users)
            //self.tableView.reloadData()
        })
        */
        search()
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
            //remove current user
            var count = 0
            for user in self.data {
                print("loop")
                if user.objectId == PFUser.currentUser()?.objectId {
                    self.data.removeAtIndex(count)
                }
                count = count+1
            }
            
            print(self.data)
            self.tableView.reloadData()
        }
        
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.data != nil {
            return self.data.count
        } //else
        return 0
        //return self.users.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        /*
        cell.textLabel?.text = self.users[indexPath.row].username
        
        //marks followers with checkmark
        
        if self.isFollowing[indexPath.row] == true {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        */
        //if self.data != nil || self.data.count > 0 {
            let obj = self.data[indexPath.row]
            cell.textLabel!.text = obj["username"] as? String
            return cell
        //}
        

        
        
        //return cell

    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You selected cell #\(indexPath.row)!")
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
