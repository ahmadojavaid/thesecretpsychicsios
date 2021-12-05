//
//  DetailChatCell.swift
//  Psychic
//
//  Created by APPLE on 1/16/19.
//  Copyright © 2019 Jobesk. All rights reserved.
//

import UIKit

class DetailChatCell: UITableViewCell {

    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var msg: UILabel!
    @IBOutlet weak var rightConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftConstraint: NSLayoutConstraint!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
