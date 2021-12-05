//
//  RequestScreen.swift
//  Psychic
//
//  Created by APPLE on 3/29/19.
//  Copyright © 2019 Jobesk. All rights reserved.
//

import UIKit

class RequestScreen: UIViewController {

    @IBOutlet weak var paypalValue: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        paypalValue.text = DEFAULTS.string(forKey: "payPalAccount")!
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backBtn(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
