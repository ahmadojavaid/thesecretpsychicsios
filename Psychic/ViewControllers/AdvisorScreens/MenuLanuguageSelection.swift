//
//  MenuLanuguageSelection.swift
//  Psychic
//
//  Created by APPLE on 4/3/19.
//  Copyright © 2019 Jobesk. All rights reserved.
//





import UIKit

class MenuLanuguageSelection: UIViewController {
    
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
    
    @IBAction func saveBtn(_ sender: Any)
    {
        self.performSegue(withIdentifier: "advHome", sender: nil)
    }
    
    
}
