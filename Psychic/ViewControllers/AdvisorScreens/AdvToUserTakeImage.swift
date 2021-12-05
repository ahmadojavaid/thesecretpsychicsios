//
//  AdvToUserTakeImage.swift
//  Psychic
//
//  Created by APPLE on 3/21/19.
//  Copyright © 2019 Jobesk. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class AdvToUserTakeImage: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    var imageCode = "abc"
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    
    @IBAction func submitButton(_ sender: Any)
    {
        
        let usName = userName.text!
        
        if usName.isEmpty
        {
            showPopup(msg: "Please Enter User Name", sender: self)
        } else if checkName(name: usName)
        {
            showPopup(msg: "User Name must not contain special character or numbers", sender: self)
        }
        else
        {
            update(name: usName)
        }
        
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    
    
    func update(name:String)
    {
        if Reach.isConnectedToNetwork()
        {
            let id = DEFAULTS.string(forKey: "user_id")!
            SVProgressHUD.show(withStatus: "updating information....")
            let baseurl = URL(string:BASE_URL+"user/"+id)!
            var parameters = Parameters()
            
            if imageCode == "abc"
            {
                parameters = ["username":name]
            }
            else
            {
                parameters = ["username":name, "profileImage":imageCode]
            }
            
            Alamofire.request(baseurl, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON{ (responseData) -> Void in
                if((responseData.result.value) != nil)
                {
                    SVProgressHUD.dismiss()
                    print("update information")
                    let a = JSON(responseData.result.value)
                    let id = "\(a["Result"]["id"])"
                    let image = "\(a["Result"]["profileImage"])"
                    let name = "\(a["Result"]["name"])"
                    let email = "\(a["Result"]["email"])"
                    DEFAULTS.set("clientLogin", forKey: "logged")
                    DEFAULTS.set(id, forKey: "user_id")
                    DEFAULTS.set(image, forKey: "user_image")
                    DEFAULTS.set(name, forKey: "user_name")
                    DEFAULTS.set(email, forKey: "user_email")
                    self.performSegue(withIdentifier: "clientHome", sender: nil)
                    
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
