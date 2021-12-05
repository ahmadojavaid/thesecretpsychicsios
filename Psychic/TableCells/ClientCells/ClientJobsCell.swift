//
//  ClientJobsCell.swift
//  Psychic
//
//  Created by APPLE on 1/11/19.
//  Copyright © 2019 Jobesk. All rights reserved.
//

import UIKit

protocol sessionTablecellDelegate{
    func closeFriendsTapped(at index:IndexPath)
}

class ClientJobsCell: UITableViewCell {

    
    @IBOutlet weak var counltLabel: UILabel!
    @IBOutlet weak var countLabelBack: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var appIcon: UIImageView!
    @IBOutlet weak var catName: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var heading: UITextView!
    @IBOutlet weak var details: UILabel!
    @IBOutlet weak var dateLabl: UILabel!
    var delegate:sessionTablecellDelegate!
    var indexPath:IndexPath!
    
    @IBOutlet weak var playVideoBtnView: UIView!
    
    @IBOutlet weak var tickImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    @IBAction func shareBtnPrssed(_ sender: Any)
    {
        self.delegate?.closeFriendsTapped(at: indexPath)
        print("I am clicked")
    }
}
