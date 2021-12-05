//
//  ClientChatCell.swift
//  Psychic
//
//  Created by APPLE on 1/16/19.
//  Copyright © 2019 Jobesk. All rights reserved.
//

import UIKit

class ClientChatCell: UITableViewCell {

    
    @IBOutlet weak var chatCounter: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userNAme: UILabel!
    @IBOutlet weak var msg: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var counterView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
