//
//  AdvisorLogin.swift
//  Psychic
//
//  Created by APPLE on 12/31/18.
//  Copyright © 2018 Jobesk. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

import FirebaseInstanceID

class AdvisorLogin: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var forgetPasswordEmail: UITextField!
    @IBOutlet weak var forgerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    let refreshToken = InstanceID.instanceID().token()!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        forgerView.isHidden = true
        
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func signupBtn(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func loginBtnPressed(_ sender: Any)
    {
        
        let email = userName.text!
        let pass = password.text!
        
        if email.isEmpty
        {
            showPopup(msg: "Please type a valid email", sender: self)
        } else if pass.isEmpty
        {
            showPopup(msg: "Please type password", sender: self)
        } else if CHECK_EMAIL(testStr: email)
        {
            loginAccount(userName: email, password: pass)
        }
        else
        {
            showPopup(msg: "Please type a valid email", sender: self)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        let animation = CABasicAnimation(keyPath: "position.x")
        animation.fromValue = 1000
        animation.toValue = 1
        animation.duration = 100
        animation.repeatCount = 100000
        collectionView.layer.add(animation, forKey: "basicAnimation")
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "advisors", for: indexPath) as! AdvisorsList
        
        cell.backgroundColor = .random
        cell.advisorImage.clipsToBounds = true
        cell.advisorImage.layer.cornerRadius = 50.0
        
        cell.advisorImage.image = UIImage(named: "face\(indexPath.row+1)")
        
        return cell
    }
    
    
    
    
    func loginAccount(userName: String, password:String)
    {
        if Reach.isConnectedToNetwork()
        {
            
            SVProgressHUD.show(withStatus: "Loading..")
            let baseurl = URL(string:BASE_URL+"advisordoLogin")!
            var parameters = Parameters()
            
            
            parameters = ["email":userName, "password":password, "advisorFcmToken":refreshToken, "devicePlatform":"1"]
            
            Alamofire.request(baseurl, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON{ (responseData) -> Void in
                if((responseData.result.value) != nil)
                {
                    SVProgressHUD.dismiss()
                    print("One Advisor Details..........")
                    let a = JSON(responseData.result.value)
                    print(a)
                    let statusCode  = "\(a["statusCode"])"
                    let statusMessage = "\(a["statusMessage"])"
                    
                    if statusCode == "1"
                    {
                        let profileStatus = "\(a["result"]["profileStatus"])"
                        let id = "\(a["result"]["id"])"
                        let email = "\(a["result"]["email"])"
                        DEFAULTS.set(email, forKey: "user_email")
                        DEFAULTS.set(id, forKey: "user_id")
                        DEFAULTS.set("\(a["result"]["legalNameOfIndividual"])", forKey: "userName")
                        DEFAULTS.set("\(a["result"]["profileImage"])", forKey: "user_image")
                        DEFAULTS.set("\(a["result"]["videoChat"])", forKey: "videoChat")
                        DEFAULTS.set("\(a["result"]["isOnline"])", forKey: "isOnline")
                        DEFAULTS.set("\(a["result"]["liveChat"])", forKey: "liveChat")
                        DEFAULTS.set("\(a["result"]["username"])", forKey: "username")
                        DEFAULTS.set("\(a["result"]["bankDetails"])", forKey: "payPalAccount")
                        if profileStatus == "0"
                        {
                            self.performSegue(withIdentifier: "advisorProfile", sender: nil)
                        }
                        else
                        {
                            DEFAULTS.set("advisorLogin", forKey: "logged")
                            let storyboard = UIStoryboard(name: "AdvisorScreens", bundle: nil)
                            let vc = storyboard.instantiateViewController(withIdentifier: "AdvisorHome") as! SWRevealViewController
                            self.navigationController?.pushViewController(vc, animated: true)
                            
                        }
                    }
                    else
                    {
                        showPopup(msg: statusMessage, sender: self)
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
    @IBAction func forgetPasswordBtn(_ sender: Any)
    {
        forgerView.isHidden = false
    }
    @IBAction func closeFOrgetView(_ sender: Any)
    {
        forgerView.isHidden = true
    }
    
    @IBAction func applyButtonPressed(_ sender: Any)
    {
        let em = forgetPasswordEmail.text!
        
        if CHECK_EMAIL(testStr: em)
        {
            forgetPassword(email:em)
        }
        else
        {
            showPopup(msg: "Please Enter a valid email", sender: self)
        }
    }
    
    
    
    func forgetPassword(email:String)
    {
        if Reach.isConnectedToNetwork()
        {
            
            SVProgressHUD.show(withStatus: "Please Wait..")
            let baseurl = URL(string:BASE_URL+"advisorforgotPassword")!
            var parameters = Parameters()
            
            
            parameters = ["email":email]
            
            Alamofire.request(baseurl, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON{ (responseData) -> Void in
                if((responseData.result.value) != nil)
                {
                    SVProgressHUD.dismiss()
                    
                    
                    let a = JSON(responseData.result.value)
                    let statusCode = "\(a["statusCode"])"
                    
                    if statusCode == "1"
                    {
                        showPopup(msg: "Password recovery mail sent to your mail box", sender: self)
                        
                    }
                    else
                    {
                        let msg = "\(a["statusMessage"])"
                        showPopup(msg: msg, sender: self)
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
