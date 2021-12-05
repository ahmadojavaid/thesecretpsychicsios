//
//  ClientCustomerSupport.swift
//  Psychic
//
//  Created by APPLE on 1/11/19.
//  Copyright © 2019 Jobesk. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import SwiftyJSON

class ClientCustomerSupport: UIViewController {

    @IBOutlet weak var heading: UITextField!
    @IBOutlet weak var suggestion: UITextView!
    @IBOutlet weak var menuBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        sideMenu(sender: self, menuBtn: menuBtn)
        
        
        if self.revealViewController() != nil
        {
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
        
        
        
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
            let baseurl = URL(string:BASE_URL+"usersupport")!
            var parameters = Parameters()
            parameters = ["suggestion":suggestion, "heading":heading, "userId":id]
            Alamofire.request(baseurl, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON{ (responseData) -> Void in
                if((responseData.result.value) != nil)
                {
                    
                    SVProgressHUD.dismiss()
                    let a = JSON(responseData.result.value)
                    let statusCode = "\(a["statusCode"])"
                    
                    if statusCode == "1"
                    {
                        
                        self.myShowPopup(msg: "Your query has been sent", sender: self)
                        
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
   
    
    
    
    func myShowPopup(msg:String, sender:UIViewController)
    {
        let myAlert = UIAlertController(title: "Alert", message: msg, preferredStyle: UIAlertController.Style.alert)
        
        let OKAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {
            (_)in
            
            self.performSegue(withIdentifier: "bbb", sender: nil)
        })
        myAlert.addAction(OKAction)
        sender.present(myAlert, animated: true, completion: nil)
    }
}
