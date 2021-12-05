//
//  ClientMenu.swift
//  Psychic
//
//  Created by APPLE on 1/8/19.
//  Copyright © 2019 Jobesk. All rights reserved.
//

import UIKit
import Nuke
import SVProgressHUD
import Alamofire
import SwiftyJSON

class ClientMenu: UIViewController {
    
    @IBOutlet weak var newChat: UIView!
    @IBOutlet weak var newOrderView: UIView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    var window: UIWindow?
    
    var gameTimer: Timer!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let string = "\(IMAGE_BASE_URL)"+DEFAULTS.string(forKey: "user_image")!
        let url = URL(string: string)
        Nuke.loadImage(with: url!, into: userImage)
        userImage.clipsToBounds = true
        userImage.layer.cornerRadius = 50
        
        runTimedCode()
        userName.text = DEFAULTS.string(forKey: "user_name")!
        
        gameTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
        
        
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func runTimedCode ()
    {
        getAmunt()
        
        
        
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
        self.gameTimer.invalidate()
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
        DEFAULTS.set("1", forKey: "walk")
        self.performSegue(withIdentifier: "logout", sender: nil)
    }
    
    @IBAction func settingBtn(_ sender: Any)
    {
        self.revealViewController().revealToggle(animated: true)
        performSegue(withIdentifier: "settingsScreen", sender: nil)
    }
    
    
    @IBAction func gotoCategories(_ sender: Any)
    {
        self.revealViewController().revealToggle(animated: true)
        
        performSegue(withIdentifier: "cat", sender: nil)
    }
    
    @IBAction func creditScreen(_ sender: Any)
    {
        
        self.revealViewController().revealToggle(animated: true)
        performSegue(withIdentifier: "buyCredit", sender: nil)
    }
    
    @IBAction func openWebSite(_ sender: Any)
    {
        guard let url = URL(string: "http://www.thesecretpsychics.com/") else { return }
        UIApplication.shared.open(url)
    }
    
    
    
    @IBAction func switchButton(_ sender: Any)
    {
        let actionsheet = UIAlertController(title: "This will log you out", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        actionsheet.addAction(UIAlertAction(title: "Logout as Client", style: UIAlertAction.Style.default, handler: { (action) -> Void in
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
        
        
        DEFAULTS.set(email, forKey: "user_email")
        
        DEFAULTS.set("1", forKey: "walk")
        let baseurl = URL(string:BASE_URL+"switch")!
        var parameters = Parameters()
        SVProgressHUD.show(withStatus: "Please Wait...")
        print("Base Url is \(baseurl)")
        parameters = ["email":email, "switch":"advisor"]
        print("Parameters are \(parameters)")
        
        Alamofire.request(baseurl, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON{ (responseData) -> Void in
            if((responseData.result.value) != nil)
            {
                SVProgressHUD.dismiss()
                let a = JSON(responseData.result.value)
                
                let new_status = "\(a["Result"]["new_status"])"
                let id = "\(a["Result"]["id"])"
                
                DEFAULTS.set(id, forKey: "user_id")
                
                if new_status == "0"
                {
                    
                    self.performSegue(withIdentifier: "getUserName", sender: nil)
                    SVProgressHUD.dismiss()
                    
                    
                }
                else
                {
                    let profileStatus = "\(a["Result"]["profileStatus"])"
                    
                    
                    print("Profile Status is \(profileStatus)")
                    let id = "\(a["Result"]["id"])"
                    let email = "\(a["Result"]["email"])"
                    DEFAULTS.set(email, forKey: "user_email")
                    DEFAULTS.set(id, forKey: "user_id")
                    DEFAULTS.set("\(a["Result"]["legalNameOfIndividual"])", forKey: "userName")
                    DEFAULTS.set("\(a["Result"]["profileImage"])", forKey: "user_image")
                    DEFAULTS.set("\(a["Result"]["videoChat"])", forKey: "videoChat")
                    DEFAULTS.set("\(a["Result"]["isOnline"])", forKey: "isOnline")
                    DEFAULTS.set("\(a["Result"]["liveChat"])", forKey: "liveChat")
                    DEFAULTS.set("\(a["Result"]["username"])", forKey: "username")
                    
                    
                    
                    if profileStatus == "0"
                    {
                        self.performSegue(withIdentifier: "abc", sender: nil)
                    }
                    else
                    {
                        DEFAULTS.set("advisorLogin", forKey: "logged")
                        let storyboard = UIStoryboard(name: "AdvisorScreens", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "AdvisorHome") as! SWRevealViewController
                        self.window = UIWindow(frame: UIScreen.main.bounds)
                        self.window?.rootViewController = vc
                        self.window?.makeKeyAndVisible()
                        
                    }
                    
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
        }// Alamofire ends here
    }
    
    func getAmunt()
    {
        
        let id = DEFAULTS.string(forKey: "user_id")!
        let baseurl = URL(string:BASE_URL+"getCredit?userId="+id+"&type=2")!
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
                    if "\(a["new_reply"])" == "0"
                    {
                        self.newOrderView.isHidden = true
                    }
                    else
                    {
                        self.newOrderView.isHidden = false
                    }
                    let amount = "\(a["credit"])"
                    self.amountLabel.text = "£ \(amount)"
                }
            }
            else
            {
                print("There was Error")
                print("Error is \(responseData.result.error)")
            }
        }// Alamofire ends here
        
        
        
    }
    
    @IBAction func languageBtn(_ sender: Any)
    {
        self.revealViewController().revealToggle(animated: true)
        self.performSegue(withIdentifier: "language", sender: nil)
    }
    
    
    
    
    @IBAction func cashBackButton(_ sender: Any)
    {
        cahsBack()
    }
    
    
    
    func cahsBack()
    {
        
        
        let id = DEFAULTS.string(forKey: "user_id")!
        let baseurl = URL(string:BASE_URL+"getCashback?userId="+id)!
        var parameters = Parameters()
        SVProgressHUD.show(withStatus: "Please Wait...")
        print("Base Url is \(baseurl)")
        parameters = [:]
        print("Parameters are \(parameters)")
        
        Alamofire.request(baseurl, method: .get, parameters: parameters, encoding: URLEncoding.default).responseJSON{ (responseData) -> Void in
            if((responseData.result.value) != nil)
            {
                SVProgressHUD.dismiss()
                
                
                let a = JSON(responseData.result.value)
                
                let statusCode = "\(a["statusCode"])"
                if statusCode == "1"
                {
                    let per = "\(a["Result"]["percentage"])"
                    let lastPurchase = "\(a["Result"]["actualAmount"])"
                    let amount = "\(a["Result"]["amount"])"
                    showPopupWithTwoMsgs(msg1: "You got \(per)% cashback", msg2: "Your  last purchase was £\(lastPurchase)\n You have received £\(amount)", sender: self)
                }
                else
                {
                    showPopupWithTwoMsgs(msg1: "Get 10% Cashback", msg2: "Make a purchase then come back and see how much cash back you earned", sender: self)
                }
                print("HeeeryMotiMeinNaChahon")
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
    
    func logoutWebCall()
    {
        if Reach.isConnectedToNetwork()
        {
            
            SVProgressHUD.show(withStatus: LOADING_STRING)
            let baseurl = URL(string:CLIENT_LOG_OUT_API)!
            var parameters = Parameters()
            
            
            parameters = ["userId":DEFAULTS.string(forKey: "user_id")!]
            
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
    
    @IBAction func clientMenu(segue: UIStoryboardSegue) {
        
    }
    
}
