//
//  PostTableViewCell.swift
//  AIEngineer
//
//  Created by Kushal Mandala on 15/12/19.
//  Copyright © 2019 Indovations. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet var postTitleLabel : UILabel!
    @IBOutlet var postDateLabel : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
