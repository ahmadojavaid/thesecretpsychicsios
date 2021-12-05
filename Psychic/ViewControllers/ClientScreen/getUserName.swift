//
//  getUserName.swift
//  Psychic
//
//  Created by APPLE on 3/21/19.
//  Copyright © 2019 Jobesk. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import SwiftyJSON

class getUserName: UIViewController {

    @IBOutlet weak var userNameText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

     
        
        
        // Do any additional setup after loading the view.
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    @IBAction func submitButton(_ sender: Any)
    {
        let usName = userNameText.text!
        if usName.isEmpty
        {
            
            showPopup(msg: "Please Enter user Name", sender: self)
        }
        else if checkAlphaNumeric(name: usName)
        {
            showPopup(msg: "User Name must not containt special characters or Numbers", sender: self)
        }
        else
        {
            
            if Reach.isConnectedToNetwork()
            {
                
                
                let id = DEFAULTS.string(forKey: "user_id")!
                let baseurl = URL(string:BASE_URL+"updateAdvisorInfo/"+id)!
                SVProgressHUD.show(withStatus: LOADING_STRING)
                
                var parameters = Parameters()
                
                
                parameters = ["username":usName]
                
                
                print("Here is paremeters")
                print(parameters)
                print("Parameters ends here")
                
                
                
                Alamofire.request(baseurl, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON{ (responseData) -> Void in
                    if((responseData.result.value) != nil)
                    {
                        SVProgressHUD.dismiss()
                        
                        
                        let a = JSON(responseData.result.value)
                        
                        let statusCode = "\(a["statusCode"])"
                        
                        if statusCode == "1"
                        {
                           self.performSegue(withIdentifier: "adScreen", sender: nil)
                            
                        }
                        else
                        {
                            showPopup(msg: "Please try later", sender: self)
                        }
                        
                        
                        
                        print(a)
                        
                    }
                    else
                    {
                        SVProgressHUD.dismiss()
                        print("There was Error")
                        print("Error is \(responseData.result.error)")
                        showPopup(msg: "Please try later", sender: self)
                    }
                }// Alamofire ends here
                
            }
            else
            {
                showPopup(msg: "Internet could not connect", sender: self)
            }
        }
    }

    
    
    
    
    
    

}
