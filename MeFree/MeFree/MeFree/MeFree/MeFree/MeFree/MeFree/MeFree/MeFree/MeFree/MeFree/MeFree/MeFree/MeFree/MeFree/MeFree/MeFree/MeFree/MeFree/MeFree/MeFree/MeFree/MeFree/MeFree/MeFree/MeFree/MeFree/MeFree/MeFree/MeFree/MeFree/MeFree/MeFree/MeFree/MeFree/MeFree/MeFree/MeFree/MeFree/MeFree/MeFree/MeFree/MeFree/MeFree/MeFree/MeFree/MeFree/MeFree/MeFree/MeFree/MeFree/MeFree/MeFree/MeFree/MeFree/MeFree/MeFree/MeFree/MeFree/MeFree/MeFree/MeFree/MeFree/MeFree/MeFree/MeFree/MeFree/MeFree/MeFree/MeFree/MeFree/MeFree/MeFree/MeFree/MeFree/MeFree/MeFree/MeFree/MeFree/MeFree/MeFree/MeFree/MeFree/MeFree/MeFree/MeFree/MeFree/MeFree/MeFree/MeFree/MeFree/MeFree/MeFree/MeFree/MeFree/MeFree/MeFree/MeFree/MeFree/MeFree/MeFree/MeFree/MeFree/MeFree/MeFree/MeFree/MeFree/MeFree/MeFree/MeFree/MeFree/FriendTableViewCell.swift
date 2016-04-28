//
//  FriendTableViewCell.swift
//  MeFree
//
//  Created by Joshua Montgomery on 4/2/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class FriendTableViewCell: UITableViewCell {
   
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellUsername: UILabel!
    @IBOutlet weak var cellStatus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
