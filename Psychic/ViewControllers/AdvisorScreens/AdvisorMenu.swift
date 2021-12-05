//
//  AdvisorMenu.swift
//  Psychic
//
//  Created by APPLE on 1/2/19.
//  Copyright © 2019 Jobesk. All rights reserved.
//

import UIKit
import Nuke
import SafariServices
import Alamofire
import SVProgressHUD
import SwiftyJSON

class AdvisorMenu: UIViewController {

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var newChat: UIView!
    @IBOutlet weak var newOrderView: UIView!
    var gameTimer: Timer!
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImage.clipsToBounds = true

            userName.text = DEFAULTS.string(forKey: "user_name")!
            let aa = DEFAULTS.string(forKey: "user_image")!
        let url = URL(string:"\(IMAGE_BASE_URL)\(aa)")
        profileImage.contentMode = .scaleAspectFill
        Nuke.loadImage(with: url!, into: profileImage)
         getAmunt()
        
        gameTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
        
    }
    @objc func runTimedCode ()
    {
        getAmunt()
        
        
        
    }
    @IBAction func advMenu(segue: UIStoryboardSegue)
    {
        
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func rateBtn(_ sender: Any)
    {
        rateApp(appId: "id959379869") { success in
            print("RateApp \(success)")
        }
    }
    @IBAction func openWebSIte(_ sender: Any)
    {
        guard let url = URL(string: "http://www.thesecretpsychics.com/") else { return }
        UIApplication.shared.open(url)

    }
    
    
    
    
    func getAmunt()
    {
        
        let id = DEFAULTS.string(forKey: "user_id")!
        let baseurl = URL(string:BASE_URL+"getCredit?userId="+id+"&type=1")!
        var parameters = Parameters()
        parameters = [:]
        
        
        Alamofire.request(baseurl, method: .get, parameters: parameters, encoding: URLEncoding.default).responseJSON{ (responseData) -> Void in
            if((responseData.result.value) != nil)
            {
                
                
                print("Switch response")
                let a = JSON(responseData.result.value)
                
                let new_status = "\(a["Result"]["new_status"])"
                print(a)
                DEFAULTS.set(id, forKey: "user_id")
                
                if new_status == "0"
                {
                    
                    
                    
                    
                    
                }
                else
                {
                    if "\(a["chat_counter"])" == "0"
                    {
                        self.newChat.isHidden = true
                    }
                    else
                    {
                        self.newChat.isHidden = false
                    }
                    
                    
                    if "\(a["pending_orders"])" == "0"
                    {
                        self.newOrderView.isHidden = true
                    }
                    else
                    {
                        self.newOrderView.isHidden = false
                    }
                    
                }
                
            }
            else
            {
                print("There was Error")
                print("Error is \(responseData.result.error)")
            }
        }// Alamofire ends here
        
        
        
    }
    
    
    
    
    func rateApp(appId: String, completion: @escaping ((_ success: Bool)->())) {
        guard let url = URL(string : "itms-apps://itunes.apple.com/app/" + appId) else {
            completion(false)
            return
        }
        guard #available(iOS 10, *) else {
            completion(UIApplication.shared.openURL(url))
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: completion)
    }
    
   
    
    @IBAction func chatBtn(_ sender: Any)
    {
//        self.revealViewController().revealToggle(animated: true)
    }
    
    
    
    
    
    
    
    @IBAction func logoutBtnPressed(_ sender: Any)
    {
        let actionsheet = UIAlertController(title: "Are you Sure?", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        actionsheet.addAction(UIAlertAction(title: "Are you sure you want to logout?", style: UIAlertAction.Style.default, handler: { (action) -> Void in
            self.logoutWebCall()
        }))
        actionsheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { (action) -> Void in
            
        }))
        self.present(actionsheet, animated: true, completion: nil)
        
    }
    
    
    
    
    func logout()
    {
        gameTimer.invalidate()
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
        DEFAULTS.set("1", forKey: "walk")
        self.performSegue(withIdentifier: "logout", sender: nil)
    }
    
    @IBAction func settingsBtn(_ sender: Any)
    {
        let storyboard = UIStoryboard(name: "ClientScreens", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "settings") as! UINavigationController
        navigationController?.pushViewController(vc,
                                                 animated: true)
    }
    
    
    @IBAction func switchButton(_ sender: Any)
    {
        
        let actionsheet = UIAlertController(title: "This will log you out", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        actionsheet.addAction(UIAlertAction(title: "Logout as Advisor", style: UIAlertAction.Style.default, handler: { (action) -> Void in
            
            
            self.nextFunction()
            
            
        }))
        
        
        
        
        actionsheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { (action) -> Void in
            
        }))
        self.present(actionsheet, animated: true, completion: nil)
    }
    
    
    
    func nextFunction()
    {
        
        let email  = DEFAULTS.string(forKey: "user_email")!

        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
        
        DEFAULTS.set("1", forKey: "walk")
        
        let baseurl = URL(string:BASE_URL+"switch")!
        var parameters = Parameters()
        SVProgressHUD.show(withStatus: "Please Wait...")
        print("Base Url is \(baseurl)")
        parameters = ["email":email, "switch":"user"]
        print("Parameters are \(parameters)")
        
        Alamofire.request(baseurl, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON{ (responseData) -> Void in
            if((responseData.result.value) != nil)
            {
                SVProgressHUD.dismiss()
                
                let a = JSON(responseData.result.value)
                
                let new_status = "\(a["Result"]["new_status"])"
                let id = "\(a["Result"]["id"])"
                
                if new_status == "0"
                {
                    DEFAULTS.set(id, forKey: "user_id")
                  self.performSegue(withIdentifier: "getUserName", sender: nil)
                }
                else
                {
                    let id = "\(a["Result"]["id"])"
                    let image = "\(a["Result"]["profileImage"])"
                    let name = "\(a["Result"]["name"])"
                    let email = "\(a["Result"]["email"])"
                    DEFAULTS.set(id, forKey: "user_id")
                    DEFAULTS.set(image, forKey: "user_image")
                    DEFAULTS.set(name, forKey: "user_name")
                    DEFAULTS.set(email, forKey: "user_email")
                    DEFAULTS.set("clientLogin", forKey: "logged")
                    self.performSegue(withIdentifier: "userHome", sender: nil)
                    
                }
                
                
                print("New Data")
                print(a)
                
                
            }
            else
            {
                SVProgressHUD.dismiss()
                print("There was Error")
                print("Error is \(responseData.result.error)")
                showPopup(msg: "Please try later", sender: self)
            }
        }
    }
    
    @IBAction func editProfileBtn(_ sender: Any)
    {
       mYshowPopup(msg: "Are you sure you want to edit? \nBeware that your profile will be sent for review and you will not be able to log in, until the review is completed.", sender: self)
    }
    func mYshowPopup(msg:String, sender:UIViewController)
    {
        let myAlert = UIAlertController(title: "Alert", message: msg, preferredStyle: UIAlertController.Style.alert)
        
        let OKAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {
            (_)in
            
            self.performSegue(withIdentifier: "ep", sender: self)
        })
        myAlert.addAction(OKAction)
        
        
        let CancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: {
            (_)in
            
            
        })
        myAlert.addAction(CancelAction)
        
        
        sender.present(myAlert, animated: true, completion: nil)
    }
    
    
    
    func logoutWebCall()
    {
        if Reach.isConnectedToNetwork()
        {
            
            SVProgressHUD.show(withStatus: LOADING_STRING)
            let baseurl = URL(string:ADV_LOG_OUT_API)!
            var parameters = Parameters()
            
            
            parameters = ["advisorId":DEFAULTS.string(forKey: "user_id")!]
            
            Alamofire.request(baseurl, method: .get, parameters: parameters, encoding: URLEncoding.default).responseJSON{ (responseData) -> Void in
                if((responseData.result.value) != nil)
                {
                    SVProgressHUD.dismiss()
                    print("Revenue...")
                    let a = JSON(responseData.result.value)
                    print(a)
                    let statusCode  = "\(a["statusCode"])"
                    if statusCode == "1"
                    {
                        self.logout()
                    }
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
