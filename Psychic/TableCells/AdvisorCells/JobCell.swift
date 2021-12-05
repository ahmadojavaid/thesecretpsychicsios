//
//  JobCell.swift
//  Psychic
//
//  Created by APPLE on 1/2/19.
//  Copyright © 2019 Jobesk. All rights reserved.
//

import UIKit

class JobCell: UITableViewCell {
    
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var jobImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var heading: UILabel!
    @IBOutlet weak var jobDesc: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var countLabelBackView: UIView!
    @IBOutlet weak var playImage: UIImageView!
    
    @IBOutlet weak var countBanck: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
