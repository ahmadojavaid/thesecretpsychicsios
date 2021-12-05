//
//  EditExprience.swift
//  Psychic
//
//  Created by APPLE on 3/7/19.
//  Copyright © 2019 Jobesk. All rights reserved.
//

import UIKit

class EditExprience: UIViewController {

    @IBOutlet weak var exp: UITextView!
    @IBOutlet weak var orderInst: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = false
        self.title = "Exprience"
        exp.text = ADVISOR_EXPRIENCE

        // Do any additional setup after loading the view.
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

    @IBAction func updateOrder(_ sender: Any)
    {
        let order = orderInst.text!
        
        if order.isEmpty
        {
            showPopup(msg: "Please share exprience", sender: self)
        }
        else
        {
            ADVISOR_EXPRIENCE = exp.text!
            self.performSegue(withIdentifier: "video", sender: nil)
        }
        
        
    }

}
