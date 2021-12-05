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
import Nuke

class EditGeneral_Information: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    
    var imageCode = "abc"
    
    
    
    
    
    
    @IBOutlet weak var sideBackBtn: UIBarButtonItem!
    @IBOutlet weak var backBtn: UIBarButtonItem!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var screenName: UITextField!
    @IBOutlet weak var serviceName: UITextField!
    @IBOutlet weak var userEmail: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImage.clipsToBounds = true
        self.title = "General Information"
        userEmail.text = DEFAULTS.string(forKey: "user_email")!
        
        sideBackBtn.target = self
        sideBackBtn.action = #selector(action)
        getUerProfile()
        
    }
    
    
    
    
    @objc func action (sender:UIButton)
    {
        // 1
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // 2
        let saveAction = UIAlertAction(title: "Discard Changes?", style: .default)
        { action -> Void in
            
           self.backScreen()
        }
        
        // 3
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        // 4
        
        optionMenu.addAction(saveAction)
        optionMenu.addAction(cancelAction)
        
        // 5
        self.present(optionMenu, animated: true, completion: nil)
    }
    func backScreen()
    {
        print("I am called")
        
        self.performSegue(withIdentifier: "adHome", sender: self)
        
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
            IMAGE_CHANGED = "1"
            PROFILE_IMAGE = imageCode
            picker.dismiss(animated: true, completion: nil)
            
        } else if let originalImage = info[.originalImage] as? UIImage {
            selectedImage = originalImage
            self.profileImage.image = selectedImage!
            self.imageCode = (profileImage.image?.jpegData(compressionQuality: 0.2)?.base64EncodedString())!
            IMAGE_CHANGED = "1"
            PROFILE_IMAGE = imageCode
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
        } else if serName.isEmpty
        {
            showPopup(msg: "Please Type a service Name", sender: self)
        } else if mail.isEmpty
        {
            showPopup(msg: "Please provide your Email", sender: self)
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
        
        
        SCREEN_NAME = screenName
        SERVICE_NAME = serviceName
        performSegue(withIdentifier: "toCategories", sender: nil)
        
        
    }
    
    
    
    func getUerProfile()
    {
        if Reach.isConnectedToNetwork()
        {
            
            let id = DEFAULTS.string(forKey: "user_id")!
            SVProgressHUD.show(withStatus: "Getting your information")
            let baseurl = URL(string:BASE_URL+"showAdvisorInfo/"+id)!
            
            
            
       
            var parameters = Parameters()
            parameters = [:]
            Alamofire.request(baseurl, method: .get, parameters: parameters, encoding: URLEncoding.default).responseJSON{ (responseData) -> Void in
                if((responseData.result.value) != nil)
                {
                    SVProgressHUD.dismiss()
                    let a = JSON(responseData.result.value)
                    print("EditProfile")
                    print(a)
                    self.serviceName.text = "\(a["Result"][0]["serviceName"])"
                    self.screenName.text = "\(a["Result"][0]["screenName"])"
                    ADV_CATEGORIES = a["Result"][0]["advisorscategories"]
                    SERVICE_DESC = "\(a["Result"][0]["aboutYourServices"])"
                    ABOUT_ME_TEXT = "\(a["Result"][0]["aboutMe"])"
                    ORDER_INSTRUCTION = "\(a["Result"][0]["instructionForOrder"])"
                    ADVISOR_VIDEO = "\(a["Result"][0]["profileVideo"])"
                    TIME_RATE = "\(a["Result"][0]["timeRate"])"//TextChatRate
                    CHAT_RATE = "\(a["Result"][0]["TextChatRate"])"
                    LGL_NAME = "\(a["Result"][0]["legalNameOfIndividual"])"
                    ADDRESS = "\(a["Result"][0]["permanentAddress"])"
                    CITY = "\(a["Result"][0]["city"])"
                    BANK_DETAILS = "\(a["Result"][0]["bankDetails"])"
                    PAYMENT = "\(a["Result"][0]["paymentThreshold"])"
                    COUNTRY = "\(a["Result"][0]["country"])"
                    ZIP_CODE = "\(a["Result"][0]["zipCode"])"
                    ADVISOR_EXPRIENCE = "\(a["Result"][0]["expirience"])"
                    let image = "\(a["Result"][0]["profileImage"])"
                    let url = URL(string: "\(IMAGE_BASE_URL)\(image)")
                    Nuke.loadImage(with: url!, into: self.profileImage)
                    DATE_OF_BIRTH = "\(a["Result"][0]["dateOfBirth"])"
                    
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

