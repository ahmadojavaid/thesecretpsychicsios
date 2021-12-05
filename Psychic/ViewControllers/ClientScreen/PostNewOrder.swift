//
//  PostNewOrder.swift
//  Psychic
//
//  Created by APPLE on 1/11/19.
//  Copyright © 2019 Jobesk. All rights reserved.
//

import UIKit
import AVFoundation
import SVProgressHUD
import SwiftyJSON
import Alamofire
import AVKit
import AVFoundation
import MediaPlayer
import AudioToolbox
import Nuke
import AVKit
import AVFoundation
import MediaPlayer
import AudioToolbox
import Nuke

import MobileCoreServices
import SVProgressHUD
import SwiftyJSON
import AudioToolbox


class PostNewOrder: UIViewController, AVPlayerViewControllerDelegate, UINavigationControllerDelegate {

    let storyboards = UIStoryboard(name: "ClientScreens", bundle: nil)
    
    var vc1 = BuyCreditSecond()
    var videoSelected = "0"
    
    @IBOutlet weak var innerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var orderBtn: UIButton!
    @IBOutlet weak var advisroName: UILabel!
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var preImage: UIImageView!
    @IBOutlet weak var questionHeading: UITextField!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var questionsDesc: UITextView!
    
    
    var cameraPicked = "0"
    var innerViewOpened = false
    @IBOutlet weak var addVIdeoView: UIView!
    var videoURL: URL? = nil
    var imagePickerController = UIImagePickerController()
    @IBOutlet weak var addBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let add = "\(IMAGE_BASE_URL)"+"\(ADVISOR_IMAGE)"
        let url = URL(string: add)
        Nuke.loadImage(with: url!, into: self.img)
        
        img.clipsToBounds = true
        img.layer.cornerRadius = 24
        
        advisroName.text = ADVISOR_NAME
        
        if self.revealViewController() != nil
        {
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
        
        self.innerViewHeight.constant = self.view.frame.height
        innerViewOpened = false
        vc1 = storyboards.instantiateViewController(withIdentifier: "BuyCreditSecond") as! BuyCreditSecond
        vc1.view.frame = self.containerView.frame
        containerView.addSubview(vc1.view)
        

        
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @IBAction func addVideoBtn(_ sender: Any)
    {
        showActionSheet()
    }
    
    
    @IBAction func orderBTn(_ sender: Any)
    {
        let head = questionHeading.text!
        let desc = questionsDesc.text!
        
        if head.isEmpty
        {
            showPopup(msg: "Please type heading", sender: self)
        } else if desc.isEmpty
        {
            showPopup(msg: "Please type Description", sender: self)
        }
        else
        {
            if videoSelected == "0"
            {
                showPopup(msg: "Please Attach a video", sender: self)
            }
            else
            {
                uploadReply(heading: head, desc: desc)
            }
            
        }
        
    }
    
    
    
    
    
    
    
    
    
    func uploadReply(heading:String, desc:String)
    {
        let id = DEFAULTS.string(forKey: "user_id")!
        orderBtn.isUserInteractionEnabled = false
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            if self.videoURL == nil
            {
                multipartFormData.append(heading.data(using: .utf8)!, withName: "order_heading")
                multipartFormData.append(desc.data(using: .utf8)!, withName: "order_details")
                multipartFormData.append(id.data(using: .utf8)!, withName: "userId")
                multipartFormData.append(ADVISOR_ID.data(using: .utf8)!, withName: "advisorId")
            }
            else
            {
                
                multipartFormData.append(self.videoURL!, withName: "order_video")
                multipartFormData.append(heading.data(using: .utf8)!, withName: "order_heading")
                multipartFormData.append(desc.data(using: .utf8)!, withName: "order_details")
                multipartFormData.append(id.data(using: .utf8)!, withName: "userId")
                multipartFormData.append(ADVISOR_ID.data(using: .utf8)!, withName: "advisorId")
            }
            
       
            
        }, to:BASE_URL+"order")
        { (result) in
            switch result {
            case .success(let upload, _ , _):
                
                upload.uploadProgress(closure: { (progress) in
                    let total = progress.totalUnitCount
                    let obt  = progress.completedUnitCount
                    let per = Double(obt) / Double(total) * 100
                    let pp = Int(per)
                    SVProgressHUD.show(withStatus: "\(pp)% Uploaded")
                    self.view.isUserInteractionEnabled = false
                })
                
                upload.responseJSON { response in
                    
                    SVProgressHUD.dismiss()
                    
                    
                    
                    let a = JSON(response.result.value)
                    let statusCode = "\(a["statusCode"])"
                    if statusCode == "1"
                    {
                                            self.myshowPopup(msg: "Your order have been posted", sender: self)
                                            self.navigationController?.popViewController(animated: true)
                        
                                            self.performSegue(withIdentifier: "clientHome", sender: nil)
                                            self.view.isUserInteractionEnabled = true
                    } else if statusCode == "403"
                    {
                        self.view.isUserInteractionEnabled = true
                         self.closeInnerView()
                    }

                    
                    
                    
                }
                
            case .failure(let encodingError):
                print("failed")
                print(encodingError)
                
            }
        }
        
        
    }
    
    
    
    @IBAction func cancelBtn(_ sender: Any)
    {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Cancel Order", style: .default , handler:{ (UIAlertAction)in
            
            self.performSegue(withIdentifier: "clientHome", sender: nil)
            
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .default , handler:{ (UIAlertAction)in
            print("User click Edit button")
        }))

        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    
    
    
    
    
    func myshowPopup(msg:String, sender:UIViewController)
    {
        let myAlert = UIAlertController(title: "Alert", message: msg, preferredStyle: UIAlertController.Style.alert)
        
        let OKAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {
            (_)in
            
            // perform any action here
            self.performSegue(withIdentifier: "clientHome", sender: nil)
        })
        myAlert.addAction(OKAction)
        sender.present(myAlert, animated: true, completion: nil)
    }
   
    @IBAction func backBtn(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
        self.performSegue(withIdentifier: "adInfo", sender: nil)
    }
}


extension PostNewOrder: UIImagePickerControllerDelegate {
 
    
    private func thumbnailForVideoAtURL(url: NSURL) -> UIImage? {
        videoSelected = "1"
        let asset = AVAsset(url: url as URL)
        let assetImageGenerator = AVAssetImageGenerator(asset: asset)
        
        var time = asset.duration
        time.value = min(time.value, 2)
        
        do {
            let imageRef = try assetImageGenerator.copyCGImage(at: time, actualTime: nil)
            return UIImage(cgImage: imageRef)
        } catch {
            print("error")
            return nil
        }
    }
    
    
    
    
 




}


extension PostNewOrder{
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        dismiss(animated: true, completion: nil)
        
        videoSelected = "1"
        
        let  rUrl = info[.mediaURL] as! URL
        
        let asset=AVAsset(url: rUrl)
        let item=AVPlayerItem(asset: asset)
        let player=AVPlayer(playerItem: item)
        let duration = Int((player.currentItem?.asset.duration.seconds)!)
        
        if duration > 180
        {
            showPopup(msg: "Please select video of Three Minute", sender: self)
        }
        else
        {
            let url = info[.mediaURL] as? URL
            
            print("VIDEO URL is \(url!)")
            UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(url!.path)
            
            
            videoURL = url
            
            self.preImage.image = thumbnailForVideoAtURL(url: videoURL as! NSURL)
            
            if cameraPicked == "0"
            {
                UISaveVideoAtPathToSavedPhotosAlbum(
                    url!.path,
                    self,
                    #selector(video(_:didFinishSavingWithError:contextInfo:)),
                    nil)
            }
        }
        
        
        
        
    }
    
    @objc func video(_ videoPath: String, didFinishSavingWithError error: Error?, contextInfo info: AnyObject) {
        let title = (error == nil) ? "Success" : "Error"
        let message = (error == nil) ? "Video was saved" : "Video failed to save"
        
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
 
    
    
    
    
    
    
   
    
    
    func showActionSheet()
    {
        let alert = UIAlertController(title: nil , message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Choose from Gallery", style: .default , handler:{ (UIAlertAction)in
            
            
            self.cameraPicked = "1"
            self.imagePickerController.sourceType = .savedPhotosAlbum
            self.imagePickerController.delegate = self
            self.imagePickerController.mediaTypes = ["public.movie"]
            
            self.present(self.imagePickerController, animated: true, completion: nil)
            
        }))
        
        alert.addAction(UIAlertAction(title: "Record from Camera", style: .default , handler:{ (UIAlertAction)in
            
            self.recordingFromCamera()
            
        }))
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    
    
    
    
    
    
    func recordingFromCamera()
    {
        self.cameraPicked = "0"
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)
        {
            print("Camera Available")
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.cameraDevice = .front
            imagePicker.allowsEditing = true
            imagePicker.videoMaximumDuration = 180
            imagePicker.mediaTypes = [kUTTypeMovie as String]
            imagePicker.allowsEditing = true
            
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            print("Camera UnAvaialable")
        }
    }
    
    
    
    
    
    @IBAction func closeBtn(_ sender: Any)
    {
        print("Close Btn pressed...")
        closeInnerView()
        
    }
    
    
    func closeInnerView()
    {
        if self.innerViewOpened
        {
            self.innerViewHeight.constant = self.view.frame.height
        }
        else
        {
            self.innerViewHeight.constant = 40
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        innerViewOpened = !innerViewOpened
    }
    
    
}
