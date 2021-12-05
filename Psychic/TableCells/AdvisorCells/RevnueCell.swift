//
//  RevnueCell.swift
//  Psychic
//
//  Created by APPLE on 3/29/19.
//  Copyright © 2019 Jobesk. All rights reserved.
//

import UIKit

class RevnueCell: UITableViewCell {

    @IBOutlet weak var refType: UILabel!
    @IBOutlet weak var amountValue: UILabel!
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
