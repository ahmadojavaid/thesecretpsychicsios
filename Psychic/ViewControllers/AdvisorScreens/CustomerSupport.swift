//
//  CustomerSupport.swift
//  Psychic
//
//  Created by APPLE on 1/7/19.
//  Copyright © 2019 Jobesk. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON

class CustomerSupport: UIViewController {
    @IBOutlet weak var heading: UITextField!
    @IBOutlet weak var suggestion: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func sendDataToServer(_ sender: Any)
    {
        let head = heading.text!
        let sugg = suggestion.text!
        
        
        if head.isEmpty
        {
            showPopup(msg: "Please type some heading", sender: self)
        } else if sugg.isEmpty
        {
            showPopup(msg: "Please type some suggestions", sender: self)
        } else
        {
            sendCustomerSupport(heading: head, suggestion: sugg)
        }
        
        
        
    }
    
    
    
    func sendCustomerSupport(heading:String, suggestion:String)
    {
        if Reach.isConnectedToNetwork()
        {
            let id = DEFAULTS.string(forKey: "user_id")!
            SVProgressHUD.show(withStatus: "Sending Data...... ")
            let baseurl = URL(string:BASE_URL+"support")!
            var parameters = Parameters()
            parameters = ["suggestion":suggestion, "heading":heading, "advisorId":id]
            Alamofire.request(baseurl, method: .get, parameters: parameters, encoding: URLEncoding.default).responseJSON{ (responseData) -> Void in
                if((responseData.result.value) != nil)
                {
                    
                    SVProgressHUD.dismiss()
                    let a = JSON(responseData.result.value)
                    let statusCode = "\(a["statusCode"])"
                    
                    if statusCode == "1"
                    {
                        
                       self.showPopupWithAction(msg: "Your suggesstions are recevied, we will do consider on top priority", sender: self)
                        
                    }
                    else
                    {
                        showPopup(msg: "There was an error, please try later", sender: self)
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
            showPopup(msg: "Could not conenct to Internet", sender: self)
        }
    }
    
    
    
    
    func showPopupWithAction(msg:String, sender:UIViewController)
    {
        let myAlert = UIAlertController(title: "Alert", message: msg, preferredStyle: UIAlertController.Style.alert)
        
        let OKAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:
        {
            (_)in
            
            self.performSegue(withIdentifier: "advHome", sender: nil)
            
        })
        myAlert.addAction(OKAction)
        sender.present(myAlert, animated: true, completion: nil)
    }
    

}
