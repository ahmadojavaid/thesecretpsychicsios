//
//  SecondLogin.swift
//  Psychic
//
//  Created by APPLE on 12/28/18.
//  Copyright © 2018 Jobesk. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
import IQKeyboardManager

class SecondLogin: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password1: UITextField!
    @IBOutlet weak var password2: UITextField!
    @IBOutlet weak var createAccountBtn: UIButton!
    @IBOutlet weak var userUName: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var checkImage: UIImageView!
    
    
    
    
    var age = "0"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bar:UINavigationBar! =  self.navigationController?.navigationBar
        bar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        bar.shadowImage = UIImage()
        bar.alpha = 0.0
        bar.backgroundColor = .clear
        
        
        
        createAccountBtn.clipsToBounds = true
        createAccountBtn.layer.cornerRadius = 10
        createAccountBtn.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        collectionView.delegate = self
        collectionView.dataSource = self
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
    
    @IBAction func ageBtnPressed(_ sender: Any)
    {
        if age == "0"
        {
            checkImage.image = UIImage(named: "check")
            age = "1"
        }
        else
        {
            checkImage.image = UIImage(named: "uncheck")
            age = "0"
        }
        
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
    
    
    
    @IBAction func createAccountBtnPressed(_ sender: Any)
    {
        
        let name = userName.text!
        let pass1 = password1.text!
        let pass2 = password2.text!
        let uName = userUName.text!
        
        
        
        if CHECK_EMAIL(testStr: name)
        {
            if name.isEmpty
            {
                showPopup(msg: "Please enter Name", sender: self)
            } else if pass1.isEmpty
            {
                showPopup(msg: "Please Enter Password", sender: self)
            } else if pass2.isEmpty
            {
                showPopup(msg: "Please Enter Confirm Password", sender: self)
            } else if pass2 != pass1
            {
                showPopup(msg: "Password Does not match", sender: self)
            } else if age == "0"
            {
                showPopup(msg: "Please make sure you are over 18 years of age", sender: self)
            } else if uName.isEmpty
                {
                showPopup(msg: "Please type a user Name", sender: self)
            } else if checkName(name: uName)
            {
                showPopup(msg: "User Name Must not contain special characters of numbers", sender: self)
            }
            else
            {
                createAccount(userName: name, password: pass2,uName: uName)
            }
        }
        else
        {
                showPopup(msg: "Invalid email Address", sender: self)
        }
    }
    
    
    
    func createAccount(userName: String, password:String, uName:String)
    {
        if Reach.isConnectedToNetwork()
        {
            
            SVProgressHUD.show(withStatus: "Creating Account")
            let baseurl = URL(string:BASE_URL+"advisorsignup")!
            var parameters = Parameters()
            parameters = ["email":userName, "password":password, "username":uName, "new_status":"1"]
            DEFAULTS.set(userName, forKey: "user_email")
            print(parameters)
            Alamofire.request(baseurl, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON{ (responseData) -> Void in
                if((responseData.result.value) != nil)
                {
                    SVProgressHUD.dismiss()
                    let a = JSON(responseData.result.value)
                    let statusCode = "\(a["statusCode"])"
                    if statusCode == "1"
                    {
                        DEFAULTS.set("\(a["Result"]["id"])", forKey: "user_id")
                        self.performSegue(withIdentifier: "advisorProfile", sender: nil)
                    }
                    else
                    {
                        let msg = "\(a["statusMessage"])"
                        showPopup(msg: msg, sender: self)
                    }
                   
                    print("SignUp Advisor")
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
    
    
    
    // MARK: - Navigation
    
    //    // In a storyboard-based application, you will often want to do a little preparation before navigation
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    //    {
    //        let vc = segue.destination as! StepOneScreen
    //        vc.imageAddress = self.imageAddrsss
    //
    //    }
    //
    
    
    
    
    @IBAction func secondLogin(segue: UIStoryboardSegue)
    {
        
    }
    

   

}
