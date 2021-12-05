//
//  Login.swift
//  Psychic
//
//  Created by APPLE on 12/28/18.
//  Copyright © 2018 Jobesk. All rights reserved.
//

import UIKit

import Alamofire
import SwiftyJSON
import SVProgressHUD
import FirebaseAuth
import GoogleSignIn
import Firebase
import FirebaseInstanceID
import Nuke

class Login: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate{

    @IBOutlet weak var forgetPasswordEmail: UITextField!
    @IBOutlet weak var rememberImage: UIImageView!
    var remember = 1
    
    var fetatures = JSON()
    var all = JSON()
    
    var ageStatus = 1
    
    @IBOutlet weak var ageCheck: UIImageView!
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var password: UITextField!
    let refreshToken = InstanceID.instanceID().token()!
    
    @IBOutlet weak var forgetView: UIView!
    @IBOutlet weak var forgotPasswordView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().shouldFetchBasicProfile = true
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        forgetView.isHidden = true
        
        
    }
    @IBAction func forgotPasswordBtn(_ sender: Any)
    {
        forgetView.isHidden = false
    }
    @IBAction func forgetPasswordBtnInvisble(_ sender: Any)
    {
        forgetView.isHidden = true
    }
    
    @IBAction func forgetPasswordAppleButtonPressed(_ sender: Any)
    {
        forgetView.isHidden = true
        let em = forgetPasswordEmail.text!
        if CHECK_EMAIL(testStr: em)
        {
                        forgetPassword(email: em)
                        forgetPasswordEmail.text = ""
        }
        else
        {
            showPopup(msg: "Please type a valid email Address", sender: self)
        }
    }
    
    
    
    
    
    @IBAction func overAgeBtn(_ sender: Any)
    {
//        if ageStatus == 0
//        {
//            ageCheck.image = UIImage(named: "check")
//            ageStatus = 1
//        }
//        else
//        {
//            ageCheck.image = UIImage(named: "uncheck")
//            ageStatus = 0
//        }
        
    }
    @IBAction func rememberBtn(_ sender: Any)
    {
        
        if remember == 1
        {
            rememberImage.image = UIImage(named: "uncheck")
            remember = 0
        }
        else
        {
            rememberImage.image = UIImage(named: "check")
            remember = 1
        }
        
        
    }

    
    
    
    
    
   
    @IBAction func googleBtnPressed(_ sender: Any)
    {
        if ageStatus == 0
        {
            showPopup(msg: "Please make user you are over 18", sender: self)
        }
        else
        {
                GIDSignIn.sharedInstance().signIn()
        }
        
        
    }
    
    
    
    @IBAction func loginBtnPressed(_ sender: Any)
    {
        
        if ageStatus == 0
        {
            showPopup(msg: "Please make user you are over 18", sender: self)
        }
        else
        {
            let em = userEmail.text!
            let pass = password.text!
            if em.isEmpty
            {
                showPopup(msg: "Please type a valid email", sender: self)
            } else if pass.isEmpty
            {
                showPopup(msg: "Please type password", sender: self)
            } else if CHECK_EMAIL(testStr: em)
            {
                userLogin(email: em, password: pass)
            }
            else
            {
                showPopup(msg: "Please type a valid email", sender: self)
            }
        }
        
       
        
        
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "clientHome"
//        {
//            let vc = segue.destination as! ClientHomeScreen
//                vc.allFeatured = self.all
//
//        }
    }
    
    
    
    
    
    
    
    func userLogin(email:String, password:String)
    {
        if Reach.isConnectedToNetwork()
        {
            
            SVProgressHUD.show(withStatus: "logging in......")
            let baseurl = URL(string:BASE_URL+"doLogin")!
            var parameters = Parameters()
            
            
            parameters = ["email":email, "password":password, "userFcmToken":refreshToken, "devicePlatform":"1"]
            
            Alamofire.request(baseurl, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON{ (responseData) -> Void in
                if((responseData.result.value) != nil)
                {
                    SVProgressHUD.dismiss()
                    
                    let a = JSON(responseData.result.value)
                    let statusCode = "\(a["statusCode"])"
                    let statusMessage = "\(a["statusMessage"])"
                    if statusCode == "200"
                    {
                        let id = "\(a["Result"]["id"])"
                        let image = "\(a["Result"]["profileImage"])"
                        let name = "\(a["Result"]["name"])"
                        let email = "\(a["Result"]["email"])"
                        DEFAULTS.set("clientLogin", forKey: "logged")
                        DEFAULTS.set(id, forKey: "user_id")
                        DEFAULTS.set(image, forKey: "user_image")
                        DEFAULTS.set(name, forKey: "user_name")
                        DEFAULTS.set(email, forKey: "user_email")
                        self.performSegue(withIdentifier: "clientHome", sender: self)
                    }
                    else
                    {
                        let msg = statusMessage
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
    
    
    func forgetPassword(email:String)
    {
        if Reach.isConnectedToNetwork()
        {
            
            SVProgressHUD.show(withStatus: "Please Wait..")
            let baseurl = URL(string:BASE_URL+"userforgotPassword")!
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
    
    
    @IBAction func backBTn(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!)
    {
        
        
        if let error = error
        {
            print(error.localizedDescription)
            return
        }
        let gmail = user.profile.email!
        self.userEmail.text = gmail
        
        
      
        
        self.socialLogin(email:gmail)
        
        self.password.isUserInteractionEnabled = false
        print("I am called......")
        print(gmail)
        
        let authentication = user.authentication
        let credential = GoogleAuthProvider.credential(withIDToken: (authentication?.idToken)!,
                                                       accessToken: (authentication?.accessToken)!)
        
        Auth.auth().signIn(with: credential) { (user, error) in
            
            
        }
        let url = user.profile.imageURL(withDimension: 320)
        
        
        let task = ImagePipeline.shared.loadImage(
            with: url!,
            progress: { _, completed, total in
                print("progress updated")
        },
            completion: { response, error in

//                self.profileImage.image = response!.image
//                self.profileImage.clipsToBounds = true
//                self.profileImage.layer.cornerRadius = 50
//
//                self.socialSignup()
        }
        )
//
//
//        self.socailLogin(userEmail: gmail, userPassword: "socialLoginPassword123456789")
    }
    
    
    
    func socialLogin(email:String)
    {
        
        if Reach.isConnectedToNetwork()
        {
            
            SVProgressHUD.show(withStatus: "logging in......")
            let baseurl = URL(string:BASE_URL+"External_Login")!
            var parameters = Parameters()
            
            
            parameters = ["email":email, "userFcmToken":refreshToken, "devicePlatform":"1"]
            
            Alamofire.request(baseurl, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON{ (responseData) -> Void in
                if((responseData.result.value) != nil)
                {
                    SVProgressHUD.dismiss()
                    
                    
                    let a = JSON(responseData.result.value)
                    let statusCode = "\(a["statusCode"])"
                    
                    
                    print("SOcial Login response.......")
                    if statusCode == "1"
                    {
                        let id = "\(a["Result"]["id"])"
                        let image = "\(a["Result"]["profileImage"])"
                        let name = "\(a["Result"]["name"])"
                        let email = "\(a["Result"]["email"])"
                        DEFAULTS.set("clientLogin", forKey: "logged")
                        DEFAULTS.set(id, forKey: "user_id")
                        DEFAULTS.set(image, forKey: "user_image")
                        DEFAULTS.set(name, forKey: "user_name")
                        DEFAULTS.set(email, forKey: "user_email")
                        self.performSegue(withIdentifier: "clientHome", sender: self)
                    }
                    else
                    {
                        let msg = "Invalid email or password, please try later"
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
