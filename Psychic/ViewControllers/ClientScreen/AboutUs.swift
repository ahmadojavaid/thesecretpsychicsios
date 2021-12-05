//
//  AboutUs.swift
//  Psychic
//
//  Created by APPLE on 2/4/19.
//  Copyright © 2019 Jobesk. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class AboutUs: UIViewController {

    @IBOutlet weak var aboutUsText: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        getAboutUs()

        // Do any additional setup after loading the view.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    func getAboutUs()
    {
        if Reach.isConnectedToNetwork()
        {
            SVProgressHUD.show(withStatus: "Getting your information")
            let baseurl = URL(string:BASE_URL+"aboutUs")!
            var parameters = Parameters()
            parameters = [:]
            Alamofire.request(baseurl, method: .get, parameters: parameters, encoding: URLEncoding.default).responseJSON{ (responseData) -> Void in
                if((responseData.result.value) != nil)
                {
                    SVProgressHUD.dismiss()
                    
                    print("About Us........")
                    
                    let a = JSON(responseData.result.value)
                    
                    self.aboutUsText.text = "\(a["Result"]["aboutUs"])"
                    
                    
                    print(a)
                    
                    
                }
                else
                {
                    print("There was Error")
                    print("Error is \(responseData.result.error)")
                    showPopup(msg: "Please try later", sender: self)
                }
            }// Alamofire ends here
            
        }
        else
        {
            showPopup(msg: "Could not conenct to Internet", sender: self)
        }
    }

    @IBAction func backBtn(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
}
