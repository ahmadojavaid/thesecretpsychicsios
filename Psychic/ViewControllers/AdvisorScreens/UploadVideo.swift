//
//  UploadVideo.swift
//  Psychic
//
//  Created by APPLE on 1/1/19.
//  Copyright © 2019 Jobesk. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
import MobileCoreServices
import AVFoundation
import Toast_Swift
class UploadVideo: UIViewController {

    @IBOutlet weak var previewImage: UIView!
    @IBOutlet weak var preImage: UIImageView!
    var imagePickerController = UIImagePickerController()
    var videoURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        preImage.clipsToBounds = true
        preImage.layer.cornerRadius = 75.0
        self.title = "Upload Video"
        // Do any additional setup after loading the view.
    }
    
    @IBAction func addVideoBtn(_ sender: Any)
    {
        imagePickerController.sourceType = .savedPhotosAlbum
        imagePickerController.delegate = self
        imagePickerController.mediaTypes = ["public.movie"]
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func nextButton(_ sender: Any)
    {
        showPopup(msg: "Please Select a video", sender: self)
    }
    

}

extension UploadVideo: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        videoURL = info[.mediaURL] //info[UIImagePickerControllerMediaURL] as? URL
//        print("videoURL:\(String(describing: videoURL))")
//        self.dismiss(animated: true, completion: nil)
//    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        videoURL = info[.mediaURL] as! URL
        

        
        
        
        let asset=AVAsset(url: videoURL!)
        let item=AVPlayerItem(asset: asset)
        let player=AVPlayer(playerItem: item)
        let duration = Int((player.currentItem?.asset.duration.seconds)!)
        
        if duration > 60
        {
            showPopupMy(msg: "Please select video of one Minute", sender: self)
            self.view.makeToast("Please select video of one Minute")
        }
        else
        {
            preImage.image = thumbnailForVideoAtURL(url: videoURL! as NSURL)
            
            let id = DEFAULTS.string(forKey: "user_id")!
            
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(self.videoURL!, withName: "profileVideo")
                multipartFormData.append(id.data(using: .utf8)!, withName: "advisorId")
            }, to:BASE_URL+"uploadVid")
            { (result) in
                switch result {
                case .success(let upload, _ , _):
                    
                    upload.uploadProgress(closure: { (progress) in
                        
                        print("uploding\(progress)")
                        
                        
                        let total = progress.totalUnitCount
                        let obt  = progress.completedUnitCount
                        
                        let per = Double(obt) / Double(total) * 100
                        
                        
                        let pp = Int(per)
                        SVProgressHUD.show(withStatus: "\(pp)% Uploaded")
                        self.view.isUserInteractionEnabled = false
                        
                        
                        
                        
                        
                    })
                    
                    upload.responseJSON { response in
                        
                        SVProgressHUD.dismiss()
                        print("done")
                       
                        self.view.isUserInteractionEnabled = true
                        self.performSegue(withIdentifier: "briefing", sender: nil)
                    }
                    
                case .failure(let encodingError):
                    print("failed")
                    print(encodingError)
                    
                }
            }
            
            
            
        }
        
        
        
        
        
        
        
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    private func thumbnailForVideoAtURL(url: NSURL) -> UIImage? {
        
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
    
    
    func showPopupMy(msg:String, sender:UIViewController)
    {
        let myAlert = UIAlertController(title: "Alert", message: msg, preferredStyle: UIAlertController.Style.alert)
        
        let OKAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {
            (_)in
            
            // perform any action here
        })
        myAlert.addAction(OKAction)
        sender.present(myAlert, animated: true, completion: nil)
    }
}
