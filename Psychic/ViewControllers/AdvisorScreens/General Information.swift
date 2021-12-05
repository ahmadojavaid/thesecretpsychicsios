//
//  General Information.swift
//  Psychic
//
//  Created by APPLE on 12/31/18.
//  Copyright © 2018 Jobesk. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import SwiftyJSON

class General_Information: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate{

    
    var imageCode = "abc"
    
    
    
    
    
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var screenName: UITextField!
    @IBOutlet weak var serviceName: UITextField!
    @IBOutlet weak var userEmail: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImage.clipsToBounds = true
        self.title = "General Information"
        userEmail.text = DEFAULTS.string(forKey: "user_email")!
        
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func takeImage(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImage: UIImage?
        if let editedImage = info[.editedImage] as? UIImage {
            selectedImage = editedImage
            self.profileImage.image = selectedImage!
            picker.dismiss(animated: true, completion: nil)
            
            self.imageCode = (profileImage.image?.jpegData(compressionQuality: 0.2)?.base64EncodedString())!

            picker.dismiss(animated: true, completion: nil)
            
        } else if let originalImage = info[.originalImage] as? UIImage {
            selectedImage = originalImage
            self.profileImage.image = selectedImage!
            self.imageCode = (profileImage.image?.jpegData(compressionQuality: 0.2)?.base64EncodedString())!
            picker.dismiss(animated: true, completion: nil)
        }
        
    }
    @IBAction func updateUserImage(_ sender: Any)
    {
        
        let scName = screenName.text!
        let serName = serviceName.text!
        let mail = userEmail.text!
        
        if scName.isEmpty
        {
            showPopup(msg: "Please Type a Screen Name", sender: self)
        }
        if checkName(name: scName)
        {
            showPopup(msg: "Screen name must not contain special characters", sender: self)
        } else if serName.isEmpty
        {
            showPopup(msg: "Please Type a service Name", sender: self)
        } else if checkName(name: serName)
        {
            showPopup(msg: "Service name must not contain special characters", sender: self)
        } else if mail.isEmpty
        {
            showPopup(msg: "Please provide your Email", sender: self)
        } else if imageCode == "abc"
        {
            showPopup(msg: "Please Select an image", sender: self)
        } else if CHECK_EMAIL(testStr: mail)
        {
            
            updateUserImage(screenName: scName, serviceName: serName)
        }
        else
        {
                showPopup(msg: "Please provide a valid email Address", sender: self)
        }
        
        
        
    }
    
    
    
    func updateUserImage(screenName:String, serviceName:String)
    {
        if Reach.isConnectedToNetwork()
        {
            
            let id = DEFAULTS.string(forKey: "user_id")!
            SVProgressHUD.show(withStatus: LOADING_STRING)
            let baseurl = URL(string:BASE_URL+"updateAdvisorInfo/"+id)!
            
            
            var parameters = Parameters()
            parameters = ["profileImage":imageCode, "screenName":screenName, "serviceName":serviceName]
            Alamofire.request(baseurl, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON{ (responseData) -> Void in
                if((responseData.result.value) != nil)
                {
                    SVProgressHUD.dismiss()
                    
                    print("Image uploaded response")
                    let a = JSON(responseData.result.value)
                    let statusCode = "\(a["statusCode"])"
                    if statusCode == "1"
                    {
                        self.performSegue(withIdentifier: "categoriesScreen", sender: nil)
                        
                    }
                    else
                    {
                        showPopup(msg: "Could not update information, please try later", sender: self)
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
