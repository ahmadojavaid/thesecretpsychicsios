//
//  ProfileInformation.swift
//  Psychic
//
//  Created by APPLE on 1/1/19.
//  Copyright © 2019 Jobesk. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftyJSON
import Alamofire

class ProfileInformation: UIViewController {

    @IBOutlet weak var serviceDesc: UITextView!
    @IBOutlet weak var aboutMeText: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = false
        self.title = "Profile Information"

        // Do any additional setup after loading the view.
    }
    

    @IBAction func updateServices(_ sender: Any)
    {
        let about = aboutMeText.text!
        let ser = serviceDesc.text!
        
        
        if about.isEmpty
        {
            showPopup(msg: "Please type in about me", sender: self)
        } else if ser.isEmpty
        {
            showPopup(msg: "Please type about your services", sender: self)
        }
        else
        {
            updateData(aboutYourServices: ser, aboutMe: about)
        }
    }
    
    
    
    func updateData(aboutYourServices:String, aboutMe:String)
    {
        if Reach.isConnectedToNetwork()
        {

            let id = DEFAULTS.string(forKey: "user_id")!
            SVProgressHUD.show(withStatus: LOADING_STRING)
            let baseurl = URL(string:BASE_URL+"updateAdvisorInfo/"+id)!
            var parameters = Parameters()
            
            parameters = ["aboutYourServices":aboutYourServices, "aboutMe":aboutMe]
            
            Alamofire.request(baseurl, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON{ (responseData) -> Void in
                if((responseData.result.value) != nil)
                {
                    SVProgressHUD.dismiss()
                    let a = JSON(responseData.result.value)

                    let statusCode = "\(a["statusCode"])"
                    
                    if statusCode == "1"
                    {
                        self.performSegue(withIdentifier: "instructionForOrder", sender: nil)
                    }
                    else
                    {
                        showPopup(msg: "Please try later", sender: self)
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
            showPopup(msg: "Internet could not connect", sender: self)
            
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
