//
//  SignUp.swift
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


class SignUp: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,GIDSignInUIDelegate, GIDSignInDelegate {
    
    @IBOutlet weak var fullName: UITextField!
    @IBOutlet weak var fbBtn: UIButton!
    @IBOutlet weak var ageCheck: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var createAccountBtn: UIButton!
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var password1: UITextField!
    @IBOutlet weak var password2: UITextField!
    var imageCode = "abc"
    var ageStatus = 0
    
    let refreshToken = InstanceID.instanceID().token()!
    override func viewDidLoad() {
        super.viewDidLoad()

        GIDSignIn.sharedInstance().shouldFetchBasicProfile = true
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        
        
        
        createAccountBtn.clipsToBounds = true
        createAccountBtn.layer.cornerRadius = 10
        createAccountBtn.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        profileImage.clipsToBounds = true
        
        let bar:UINavigationBar! =  self.navigationController?.navigationBar
        bar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        bar.shadowImage = UIImage()
        
        bar.alpha = 0.0
        fbBtn.addTarget(self, action: #selector(handleCustomFBLogin), for: .touchUpInside)
        
        
        
        
    }
    
    @IBAction func ageBtn(_ sender: Any)
    {
        if ageStatus == 0
        {
            ageCheck.image = UIImage(named: "check")
            ageStatus = 1
        }
        else
        {
            ageCheck.image = UIImage(named: "uncheck")
            ageStatus = 0
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
    
    
    
    
    
    
    
    
    @IBAction func createBtnPressed(_ sender: Any)
    {
        
        if ageStatus == 0
        {
            showPopup(msg: "Please make sure you are over 18 years of age", sender: self)
        }
        else
        {
            
        
        
        
        let name = fullName.text!
        let email = userEmail.text!
        let pass1 = password1.text!
        let pass2 = password2.text!
        
        if name.isEmpty
        {
            showPopup(msg: "Please Enter Full Name", sender: self)
        } else if email.isEmpty
        {
            showPopup(msg: "Please type valid email", sender: self)
            userEmail.becomeFirstResponder()
        } else if CHECK_EMAIL(testStr: email)
        {
            
            if pass1.isEmpty
            {
                showPopup(msg: "Please enter password", sender: self)
                password1.becomeFirstResponder()
            } else if pass2.isEmpty
            {
                showPopup(msg: "Please enter confirm password", sender: self)
                password2.becomeFirstResponder()
            } else if imageCode == "abc"
            {
               showPopup(msg: "Please select an image", sender: self)
            } else if pass2 != pass1
            {
                showPopup(msg: "Password does not match", sender: self)
            } else
            {
                createClientAccount(password: pass1, userEmail: email, name:name)
            }
            
            
        } else
        {
            showPopup(msg: "Please enter a valid email", sender: self)
            userEmail.becomeFirstResponder()
        }
            
            
        
        }
        
        
    }
    
    


    
    
    
    
    @IBAction func createAccount(_ sender: Any)
    {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        
        var selectedImage: UIImage?
        if let editedImage = info[.editedImage] as? UIImage
        {
            selectedImage = editedImage
            self.profileImage.image = selectedImage!
            let imageData: Data? = profileImage.image?.jpegData(compressionQuality: 0.4)
            self.imageCode = imageData?.base64EncodedString(options: .lineLength64Characters) ?? ""
            picker.dismiss(animated: true, completion: nil)
        } else if let originalImage = info[.originalImage] as? UIImage
        {
            selectedImage = originalImage
            self.profileImage.image = selectedImage!
            let imageData: Data? = profileImage.image?.jpegData(compressionQuality: 0.2)
            self.imageCode = imageData?.base64EncodedString(options: .lineLength64Characters) ?? ""
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    
    
    
    func createClientAccount(password:String, userEmail: String, name: String)
    {
        if Reach.isConnectedToNetwork()
        {
            
            SVProgressHUD.show(withStatus: "Creating your account... Please wait...")
            let baseurl = URL(string:BASE_URL+"signup")!
            var parameters = Parameters()
            
            parameters = ["email":userEmail, "password":password, "profileImage":self.imageCode, "name":name, "new_status":"1"]
            
            Alamofire.request(baseurl, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON{ (responseData) -> Void in
                if((responseData.result.value) != nil)
                {
                    SVProgressHUD.dismiss()
                    let a = JSON(responseData.result.value)
                    
                    let statusCode = "\(a["statusCode"])"
                    
                    if statusCode == "200"
                    {
                        self.navigationController?.popViewController(animated: true)
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

    @IBAction func backBtn(_ sender: Any)
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
                
                                self.profileImage.image = response!.image
                                self.profileImage.clipsToBounds = true
                                self.profileImage.layer.cornerRadius = 50
                let imageData = self.profileImage.image?.jpegData(compressionQuality: 1)
                self.imageCode = (imageData! as Data).base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: UInt(0)))
                
                
                self.socialLogin(email:gmail, name: user.profile.name!)
        }
            
            
            
        )
        
        
        
        //
        //
        //        self.socailLogin(userEmail: gmail, userPassword: "socialLoginPassword123456789")
    }
    
    
    
    func socialLogin(email:String, name:String)
    {
        
        if Reach.isConnectedToNetwork()
        {
            
            SVProgressHUD.show(withStatus: LOADING_STRING)
            let baseurl = URL(string:BASE_URL+"External_Login")!
            var parameters = Parameters()
            
            
            parameters = ["email":email, "userFcmToken":refreshToken, "name":name, "profileImage":self.imageCode]
            
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
//                        let name = "\(a["Result"]["name"])"
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
    
    @objc func handleCustomFBLogin()
    {
            showPopup(msg: "Will be added soon", sender: self)
    }
    
    
    
    
    
    
    
}

