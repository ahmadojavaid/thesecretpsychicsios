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

class EditUploadVideo: UIViewController {
    
    @IBOutlet weak var previewImage: UIView!
    @IBOutlet weak var preImage: UIImageView!
    var imagePickerController = UIImagePickerController()
    var videoURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Choose Video"
        preImage.clipsToBounds = true
        preImage.layer.cornerRadius = 75.0
        let path = URL(string: "\(BASE_URL)\(ADVISOR_VIDEO)")
        
        preImage.image = getThumbnailFromAddress(path: path!)
        
        let backButton = UIBarButtonItem (image: UIImage(named: "chotaBack")!, style: .plain, target: self, action: #selector(GoToBack))
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.hidesBackButton = true
        
        
        
        
    }
    @objc func GoToBack()
    {
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
    
    @IBAction func addVideoBtn(_ sender: Any)
    {
        imagePickerController.sourceType = .savedPhotosAlbum
        imagePickerController.delegate = self
        imagePickerController.mediaTypes = ["public.movie"]
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func gotoNext(_ sender: Any)
    {
            VIDEO_CHANGED = "0"
            self.performSegue(withIdentifier: "paymentScreensss", sender: nil)
        
        
    }
    
    
}

extension EditUploadVideo: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    //        videoURL = info[.mediaURL] //info[UIImagePickerControllerMediaURL] as? URL
    //        print("videoURL:\(String(describing: videoURL))")
    //        self.dismiss(animated: true, completion: nil)
    //    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        
        videoURL = info[.mediaURL] as! URL
        

        let asset=AVAsset(url: videoURL!)
        let item=AVPlayerItem(asset: asset)
        let player=AVPlayer(playerItem: item)
        let duration = Int((player.currentItem?.asset.duration.seconds)!)
        
        if duration > 60
        {
            showPopup(msg: "Please select video of one Minute", sender: self)
        }
        else
        {
            preImage.image = thumbnailForVideoAtURL(url: videoURL! as NSURL)
            
            VIDEO_URL = videoURL
            AAAA = "1"
            
            print("VIdeo is changed")
            
           
            
            
            
//            Alamofire.upload(multipartFormData: { (multipartFormData) in
//                multipartFormData.append(self.videoURL!, withName: "profileVideo")
//                multipartFormData.append(id.data(using: .utf8)!, withName: "advisorId")
//            }, to:BASE_URL+"uploadVid")
//            { (result) in
//                switch result {
//                case .success(let upload, _ , _):
//                    upload.uploadProgress(closure: { (progress) in
//
//                        print("uploding\(progress)")
//
//
//                        let total = progress.totalUnitCount
//                        let obt  = progress.completedUnitCount
//
//                        let per = Double(obt) / Double(total) * 100
//
//
//                        let pp = Int(per)
//                        SVProgressHUD.show(withStatus: "\(pp)% Uploaded")
//                        self.view.isUserInteractionEnabled = false
//
//
//
//
//
//                    })
//
//                    upload.responseJSON { response in
//
//                        SVProgressHUD.dismiss()
//                        print("done")
//
//                        self.view.isUserInteractionEnabled = true
//                        self.performSegue(withIdentifier: "briefing", sender: nil)
//                    }
//
//                case .failure(let encodingError):
//                    print("failed")
//                    print(encodingError)
//
//                }
//            }
        
            
            
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
    
    
    
    
    func getThumbnailFromAddress(path: URL) -> UIImage? {
        
        do {
            
            let asset = AVURLAsset(url: path , options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            
            return thumbnail
            
        } catch let error {
            
            print("*** Error generating thumbnail: \(error.localizedDescription)")
            
            return UIImage(named: "no-vidoe")
            
        }
        
    }
}

