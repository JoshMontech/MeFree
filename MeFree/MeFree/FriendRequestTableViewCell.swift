//
//  FriendRequestTableViewCell.swift
//  MeFree
//
//  Created by Joshua Montgomery on 3/30/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class FriendRequestTableViewCell: UITableViewCell {

    @IBOutlet weak var acceptButton: UIButton!
    
    @IBOutlet weak var rejectButton: UIButton!

    @IBOutlet weak var nameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
