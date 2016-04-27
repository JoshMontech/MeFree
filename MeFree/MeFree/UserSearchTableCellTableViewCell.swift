//
//  UserSearchTableCellTableViewCell.swift
//  MeFree
//
//  Created by Joshua Montgomery on 4/26/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class UserSearchTableCellTableViewCell: UITableViewCell {

    @IBOutlet weak var cellText: UILabel!
    @IBOutlet weak var cellImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
