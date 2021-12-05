//
//  PrivacyPoliceyClient.swift
//  Psychic
//
//  Created by APPLE on 2/4/19.
//  Copyright © 2019 Jobesk. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import SwiftyJSON


class PrivacyPoliceyClient: UIViewController {

    @IBOutlet weak var privacyText: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        getPrivacyPolicey()
        // Do any additional setup after loading the view.
    }
    

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func getPrivacyPolicey()
    {
        if Reach.isConnectedToNetwork()
        {
            SVProgressHUD.show(withStatus: "Getting your information")
            let baseurl = URL(string:BASE_URL+"getprivacypolicies")!
            var parameters = Parameters()
            parameters = [:]
            Alamofire.request(baseurl, method: .get, parameters: parameters, encoding: URLEncoding.default).responseJSON{ (responseData) -> Void in
                if((responseData.result.value) != nil)
                {
                    SVProgressHUD.dismiss()
                    
                    
                    let a = JSON(responseData.result.value)
                    self.privacyText.text = "\(a["Result"]["privacy"])"
                    
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

}
