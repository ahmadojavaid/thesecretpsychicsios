//
//  OneRevenue.swift
//  Psychic
//
//  Created by APPLE on 3/29/19.
//  Copyright © 2019 Jobesk. All rights reserved.
//

import UIKit
import SwiftyJSON

class OneRevenue: UIViewController {

    @IBOutlet weak var ref1: UILabel!
    @IBOutlet weak var ref2: UILabel!
    @IBOutlet weak var ref3: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var earningLabel: UILabel!
    @IBOutlet weak var trId: UILabel!
    
    
    
    
    
    
    var oneValue = JSON()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        ref1.text = "\(oneValue["refrence"])"
        ref2.text = "\(oneValue["refrence"])"
        ref3.text = "\(oneValue["refrence"])"
        
        
//        self.dateLabel.text = "\(fullNameArr[0])"
//        self.timeLabel.text = "\(fullNameArr[1])"
        self.earningLabel.text = "£ \(oneValue["credit"])"
        self.trId.text = "\(oneValue["id"])"
        
        
        
        
        
        let fulltime: String = "\(oneValue["created_at"])"
        let fullNameArr = fulltime.components(separatedBy: " ")
        
        let dateString = fullNameArr[0] // change to your date format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: dateString)
        
        dateFormatter.dateFormat = "dd-MM-YYYY"
        let goodDate = dateFormatter.string(from: date!)
        self.dateLabel.text = goodDate
        print("The Good Date is \(goodDate)")
        
        let dateAsString = fullNameArr[1]
        dateFormatter.dateFormat = "HH:mm:ss"
        
        let time = dateFormatter.date(from: dateAsString)
        dateFormatter.dateFormat = "h:mm a"
        let Date12 = dateFormatter.string(from: time!)
        self.timeLabel.text = Date12
        
//        cell.dateLabel.text = "\(Date12) \(goodDate)"
        
        
        
    }
    
    @IBAction func backBtn(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}
