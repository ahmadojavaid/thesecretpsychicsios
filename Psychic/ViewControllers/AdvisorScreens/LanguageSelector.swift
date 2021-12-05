//
//  LanguageSelector.swift
//  Psychic
//
//  Created by APPLE on 12/28/18.
//  Copyright © 2018 Jobesk. All rights reserved.
//

import UIKit

class LanguageSelector: UIViewController {

    @IBOutlet weak var segment: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        let myBlueColor = UIColor(red: 0, green: 116, blue: 205)
        self.title = "Language"
        
        self.segment.layer.cornerRadius = 25.0;
        self.segment.layer.borderColor = myBlueColor.cgColor
        self.segment.layer.borderWidth = 1
        self.segment.layer.masksToBounds = true
        
       

    }
    
    


}
