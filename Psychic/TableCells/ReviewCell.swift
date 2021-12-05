//
//  ReviewCell.swift
//  Psychic
//
//  Created by APPLE on 1/9/19.
//  Copyright © 2019 Jobesk. All rights reserved.
//

import UIKit

class ReviewCell: UITableViewCell {

    
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var oneStar: UIImageView!
    @IBOutlet weak var twoStar: UIImageView!
    @IBOutlet weak var threeStar: UIImageView!
    @IBOutlet weak var fourStar: UIImageView!
    @IBOutlet weak var fiveStar: UIImageView!
    
    @IBOutlet weak var reviewDetails: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
