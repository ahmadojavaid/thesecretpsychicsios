//
//  EditProfile.swift
//  Psychic
//
//  Created by APPLE on 2/4/19.
//  Copyright © 2019 Jobesk. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
import Nuke
import CropViewController

class EditProfile: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CropViewControllerDelegate {

    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userEmail: UITextField!
    var imageCode = "abc"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let imgAddres = DEFAULTS.string(forKey: "user_image")!
        let url = URL(string: "\(IMAGE_BASE_URL)\(imgAddres)")
        Nuke.loadImage(with: url!, into: userImage)
        userName.text = DEFAULTS.string(forKey: "user_name")!
        userEmail.text = DEFAULTS.string(forKey: "user_email")!
        userEmail.isUserInteractionEnabled = false
        
        
        saveBtn.clipsToBounds = true
        saveBtn.layer.cornerRadius = 10
        saveBtn.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        
        
        
    }
    
    @IBAction func addImageBtn(_ sender: Any)
    {
        
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        
        var selectedImage: UIImage?
        if let editedImage = info[.editedImage] as? UIImage
        {
            selectedImage = editedImage
            self.userImage.image = selectedImage!
            let imageData: Data? = userImage.image?.jpegData(compressionQuality: 0.4)
            self.imageCode = imageData?.base64EncodedString(options: .lineLength64Characters) ?? ""
            picker.dismiss(animated: true, completion: nil)
        } else if let originalImage = info[.originalImage] as? UIImage
        {
            selectedImage = originalImage
            self.userImage.image = selectedImage!
            let imageData: Data? = userImage.image?.jpegData(compressionQuality: 0.2)
            self.imageCode = imageData?.base64EncodedString(options: .lineLength64Characters) ?? ""
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    
    
    
    @IBAction func backBtn(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
        //self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func updateProfileBtn(_ sender: Any)
    {
        let name = userName.text!
        
        if name.isEmpty
        {
            showPopup(msg: "Please type your name ", sender: self)
        }
        else
        {
            DEFAULTS.set(name, forKey: "user_name")
            updateUserInformation(name:name)
        }
        
        
    }
    
    

    func updateUserInformation(name:String)
    {
        if Reach.isConnectedToNetwork()
        {
            let id = DEFAULTS.string(forKey: "user_id")!
            SVProgressHUD.show(withStatus: "updating information....")
            let baseurl = URL(string:BASE_URL+"user/"+id)!
            var parameters = Parameters()
            if imageCode == "abc"
            {
                parameters = ["name":name]
            }
            else
            {
                parameters = ["name":name, "profileImage":imageCode]
            }
            
            
            Alamofire.request(baseurl, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON{ (responseData) -> Void in
                if((responseData.result.value) != nil)
                {
                    SVProgressHUD.dismiss()
                    
                    print("update information")
                    let a = JSON(responseData.result.value)
                    
                    
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
