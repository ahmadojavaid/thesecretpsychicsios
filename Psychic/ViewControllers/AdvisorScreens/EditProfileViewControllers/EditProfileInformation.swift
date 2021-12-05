//
//  EditProfileInformation.swift
//  Psychic
//
//  Created by APPLE on 1/18/19.
//  Copyright © 2019 Jobesk. All rights reserved.
//

import UIKit

class EditProfileInformation: UIViewController {

    @IBOutlet weak var aboutServices: UITextView!
    @IBOutlet weak var aboutMe: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Profile Information"
        
        aboutMe.text = ABOUT_ME_TEXT
        aboutServices.text = SERVICE_DESC
        
        let backButton = UIBarButtonItem (image: UIImage(named: "chotaBack")!, style: .plain, target: self, action: #selector(GoToBack))
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.hidesBackButton = true
        
        
        
        
    }
    @objc func GoToBack()
    {
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // 2
        let saveAction = UIAlertAction(title: "Discard Changes?", style: .default)
        { action -> Void in
            
            self.backScreen()
        }
        
        // 3
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        // 4
        
        optionMenu.addAction(saveAction)
        optionMenu.addAction(cancelAction)
        
        // 5
        self.present(optionMenu, animated: true, completion: nil)
    }
    func backScreen()
    {
        print("I am called")
        
        self.performSegue(withIdentifier: "adHome", sender: self)
        
    }
    
    @IBAction func nextBtn(_ sender: Any)
    {
        let aboutSer = aboutServices.text!
        let me =  aboutMe.text!
        
        if aboutSer.isEmpty
        {
            showPopup(msg: "Please desribe your services", sender: self)
        } else if me.isEmpty
        {
            showPopup(msg: "Please explain about you", sender: self)
        }
        else
        {
            SERVICE_DESC = aboutSer
            ABOUT_ME_TEXT = me
            self.performSegue(withIdentifier: "orderInst", sender: nil)
        }
        
    }
    


}
