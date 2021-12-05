//
//  JobDetails.swift
//  Psychic
//
//  Created by APPLE on 1/2/19.
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

import MobileCoreServices
import SVProgressHUD
import SwiftyJSON
import AudioToolbox



class JobDetails: UIViewController, AVPlayerViewControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var conterBack: UIView!
    
    @IBOutlet weak var RecordButton: UIButton!
    var videoAndImageReview = UIImagePickerController()
    
    @IBOutlet weak var containerHeight: NSLayoutConstraint!
    var captureSession = AVCaptureSession()
    
    var indicator: UIActivityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
  
    
    var cameraPicked = "0"
    var videoSelected = "0"
    
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var dd: UITextView!
    @IBOutlet weak var commentConstraint: NSLayoutConstraint!
    @IBOutlet weak var replyPlayBtn: UIButton!
    @IBOutlet weak var replyVideoView: UIView!
    @IBOutlet weak var commentsUpperView: NSLayoutConstraint!
    @IBOutlet weak var reviewBtnConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainScrolView: UIScrollView!
    @IBOutlet weak var bottomContraint: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var videoHeight: NSLayoutConstraint!
    @IBOutlet weak var descText: UILabel!
    @IBOutlet weak var video_VIew: UIView!
    @IBOutlet weak var addVideo: UILabel!
    @IBOutlet weak var replyStatus: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var btnsView: UIView!
    @IBOutlet weak var reViewBtn: UIButton!
    @IBOutlet weak var previewImageView: UIView!
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var preImg: UIImageView!
    @IBOutlet weak var addVideoView: UIView!
    var imagePickerController = UIImagePickerController()
    @IBOutlet weak var commentsView: UIView!
    var userId = String()
    var videoURL: URL?
    var order_video = String()
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var heading: UILabel!
    @IBOutlet weak var videoNotAttached: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var replyComments: UITextView!
    @IBOutlet weak var replyView: UIView!
    @IBOutlet weak var grayView: UIView!
    
    
    
    
    var netImage1 = UIImage()
    var netImage2 = UIImage()
    var videoAddressString = String()
    var userNameString = String()
    var questionTitleHEadingString = String()
    var imageAddressString = String()
    var countLabelString = String()
    var questionDescString = String()
    var jobIdString = String()
    var declineScreen = DeclineReason()
    var isCompleted = String()
    
    
    var replyVideo = String()
    var replyCommentsString = String()
    
    
    
    
    @IBOutlet weak var heightConst: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateIsSeen()
      
        descText.text = questionDescString
        commentsView.layer.cornerRadius = 10
        commentsView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        userName.text = userNameString
        heading.text = questionTitleHEadingString
        let count = Int(countLabelString)! + 1
        countLabel.text = "\(count)"
        userName.text = userNameString
        
        previewImage.clipsToBounds = true
        previewImage.layer.cornerRadius = 100
        
       previewImageView.backgroundColor = .clear
        print("Oder Video is ")
        print("\(BASE_URL)"+"\(videoAddressString)")
        
       
        print("reply Video is ")
        print("\(BASE_URL)"+"\(replyVideo)")
        

        reViewBtn.isHidden = true
//        heightConst.constant = 1150
        let url = URL(string:"\(IMAGE_BASE_URL)\(imageAddressString)")
        Nuke.loadImage(with: url!, into: userImage)
        
        
        if order_video == "0"
        {
            videoHeight.constant = 0
            video_VIew.isHidden = true
        }
        else
        {
            
            videoHeight.constant = 280
            video_VIew.isHidden = false
        }
        
    
        
        DispatchQueue.global().async {
            let url1 = URL(string: "\(BASE_URL)"+"\(self.replyVideo)")
            let asset = AVAsset(url: url1!)
            let assetImgGenerate : AVAssetImageGenerator = AVAssetImageGenerator(asset: asset)
            assetImgGenerate.appliesPreferredTrackTransform = true
            let time = CMTimeMake(value: 1, timescale: 2)
            let img = try? assetImgGenerate.copyCGImage(at: time, actualTime: nil)
            if img != nil {
                let frameImg  = UIImage(cgImage: img!)
                DispatchQueue.main.async(execute: {
                    print("I m here")
                    self.preImg.isHidden = false
                    self.preImg.image = frameImg
                })
            }
        }
        
        
        
        _ = DispatchQueue.global(qos: .userInteractive).async
            {
                
                
                
                if self.videoAddressString.count > 10
                {
                    self.netImage1 = self.createThumbnailOfVideoFromRemoteUrl(url:"\(BASE_URL)"+"\(self.videoAddressString)")!
                    if self.isCompleted == "1"
                    {
                        
      
                    }
                    DispatchQueue.main.async
                        {
                            self.previewImage.image = self.netImage1
                            let size = CGSize(width: self.previewImageView.frame.width, height: self.previewImageView.frame.height)
                            self.previewImage.image = self.previewImage.image!.resizeImage(targetSize: size)
                            
                    }
                }
                
                
        }
        
      
        
        
        
        if isCompleted == "0"
        {
            conterBack.backgroundColor = myBlueColor
            containerView.backgroundColor = myBlueColor
            btnsView.isHidden = false
            reViewBtn.isHidden = true
            replyPlayBtn.isHidden = true
            
        } else if isCompleted == "1"
        {
            
            conterBack.backgroundColor = myGreenColor
            containerView.backgroundColor = myGreenColor
            btnsView.isHidden = true
            replyView.isHidden = false
            replyComments.text = replyCommentsString
            reviewBtnConstraint.constant = 410
            reViewBtn.isHidden = true
            addVideoView.isHidden = true
            self.addVideo.text = ""
            preImg.isHidden = true
            dd.isEditable = false
            if replyVideo == "0"
            {
                commentConstraint.constant = -190
            }
        } else if isCompleted == "3"
        {
            conterBack.backgroundColor = myRedColor
            containerView.backgroundColor = myRedColor
            btnsView.isHidden = true
            replyView.isHidden = false
            replyView.isHidden = true
            replyStatus.text = "You have declined this order"
            replyStatus.textColor = myRedColor
            reViewBtn.isHidden = true
        }
        
   
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func playVideoBtn(_ sender: Any)
    {
        let videoURL = URL(string: "\(BASE_URL)"+"\(videoAddressString)")
        let player = AVPlayer(url: videoURL!)
        let playervc = AVPlayerViewController()
        playervc.delegate = self
        playervc.player = player
        self.present(playervc, animated: true) {
            playervc.player!.play()
        }
    }
    
    @IBAction func playReplyVideo(_ sender: Any)
    {
        
        let videoURL = URL(string: "\(BASE_URL)"+"\(replyVideo)")
        let player = AVPlayer(url: videoURL!)
        let playervc = AVPlayerViewController()
        playervc.delegate = self
        playervc.player = player
        self.present(playervc, animated: true) {
            playervc.player!.play()
        }
    }
    
    @IBAction func addVideoBtn(_ sender: Any)
    {
        
        
      showActionSheet()
        
 
    }
    
    
    

    
    @IBAction func replyAdvisor(_ sender: Any)
    {
        if videoSelected == "0"
        {
            
            showPopup(msg: "Please Attach Video", sender: self)
            
        }
        else
        {
            
            indicator.center = view.center
            view.addSubview(indicator)
            indicator.bringSubviewToFront(view)
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
            let  transform:CGAffineTransform = CGAffineTransform(scaleX: 1.5, y: 1.5);
            indicator.transform = transform;
            
            self.view.isUserInteractionEnabled = false
            indicator.startAnimating()
            
            
            
            let aa = replyComments.text!
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                
                if self.videoURL == nil
                {
                    
                    let id = DEFAULTS.string(forKey: "user_id")!
                    multipartFormData.append(id.data(using: .utf8)!, withName: "advisorId")
                    multipartFormData.append(self.userId.data(using: .utf8)!, withName: "userId")
                    multipartFormData.append("1".data(using: .utf8)!, withName: "isCompleted")
                    multipartFormData.append(aa.data(using: .utf8)!, withName: "reply_details")
                }
                else
                {
                    let id = DEFAULTS.string(forKey: "user_id")!
                    multipartFormData.append(id.data(using: .utf8)!, withName: "advisorId")
                    multipartFormData.append(self.userId.data(using: .utf8)!, withName: "userId")
                    multipartFormData.append(self.videoURL!, withName: "reply_Video")
                    multipartFormData.append("1".data(using: .utf8)!, withName: "isCompleted")
                    multipartFormData.append(aa.data(using: .utf8)!, withName: "reply_details")
                }
                
                
            }, to:BASE_URL+"order/"+jobIdString)
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
                        print("done")
                        self.showPopupWithAction(msg: "Reply has been sent", sender: self)
                        
                        self.indicator.stopAnimating()
                        self.view.isUserInteractionEnabled = true
                        
                        
                        
                    }
                    
                case .failure(let encodingError):
                    print("failed")
                    print(encodingError)
                    
                }
            }
        }
        
        
        
        
        
    }
    
    
    
    

    
    
    func createThumbnailOfVideoFromRemoteUrl(url: String) -> UIImage? {
        let asset = AVAsset(url: URL(string: url)!)
        let assetImgGenerate = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        //Can set this to improve performance if target size is known before hand
        //assetImgGenerate.maximumSize = CGSize(width,height)
        let time = CMTimeMakeWithSeconds(1.0, preferredTimescale: 600)
        do {
            let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
            let thumbnail = UIImage(cgImage: img)
            return thumbnail
        } catch {
            print(error.localizedDescription)
            return UIImage(named: "no-video")
        }
    }
    
    
    
    func showPopupWithAction(msg:String, sender:UIViewController)
    {
        let myAlert = UIAlertController(title: "Alert", message: msg, preferredStyle: UIAlertController.Style.alert)
        
        let OKAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {
            (_)in
            
            self.performSegue(withIdentifier: "advHome", sender: nil)
        })
        myAlert.addAction(OKAction)
        sender.present(myAlert, animated: true, completion: nil)
    }

    
    func thumbnailImageFor(fileUrl:URL) -> UIImage? {
        
        preImg.isHidden = false
        videoSelected = "1"
        let video = AVURLAsset(url: fileUrl, options: [:])
        let assetImgGenerate = AVAssetImageGenerator(asset: video)
        assetImgGenerate.appliesPreferredTrackTransform = true
        
        let videoDuration:CMTime = video.duration
        let durationInSeconds:Float64 = CMTimeGetSeconds(videoDuration)
        
        let numerator = Int64(1)
        let denominator = videoDuration.timescale
        let time = CMTimeMake(value: numerator, timescale: denominator)
        
        do {
            let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
            let thumbnail = UIImage(cgImage: img)
          
            return thumbnail
        } catch {
            print(error)
            return nil
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func greenBtn(_ sender: Any)
    {
        reViewBtn.isHidden = false
        reviewBtnConstraint.constant = 480
        btnsView.isHidden = true
        replyView.isHidden = false
        
        replyVideoView.isHidden = false
        commentsUpperView.constant = 8
    }
    @IBAction func redBtn(_ sender: Any)
    {
        
        declineScreen = Bundle.main.loadNibNamed("DeclineReason", owner: self, options: nil)?[0] as! DeclineReason
        declineScreen.frame = self.view.frame
        btnsView.isHidden = true
        
        declineScreen.submitReasonBtn.addTarget(self, action: #selector(submitReason(_:)), for: .touchUpInside)
        declineScreen.cancelBtn.addTarget(self, action: #selector(cancelBtn(_:)), for: .touchUpInside)
        self.view.addSubview(declineScreen)
    }
    @objc func cancelBtn(_ sender: UIButton!)
    {
        
       declineScreen.removeFromSuperview()
        btnsView.isHidden = false
    }
    
    
    @objc func submitReason(_ sender: UIButton!)
    {
        
        
        
        let reason = declineScreen.reasonText.text!
        
        if reason.isEmpty
        {
            showPopup(msg: "Please type a reason", sender: self)
        }
        else
        {
            
            orderDeclineServerCall(reason: reason)
        }
        
        
        
//        startTest.removeFromSuperview()
        
    }
    
    
    func orderDeclineServerCall(reason:String)
    {
        decline(reason:reason)
    }
    
    
    
    
}



extension JobDetails: UIImagePickerControllerDelegate{

    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        dismiss(animated: true, completion: nil)
        
        
        
        videoSelected = "1"
        //            mediaType == (kUTTypeMovie as String)
        let url = info[.mediaURL] as? URL
        
        print("VIDEO URL is \(url!)")
        UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(url!.path)
        
        
        videoURL = url
        
        self.preImg.image = thumbnailForVideoAtURL(url: videoURL as! NSURL)
        
        if cameraPicked == "0"
        {
            UISaveVideoAtPathToSavedPhotosAlbum(
                url!.path,
                self,
                #selector(video(_:didFinishSavingWithError:contextInfo:)),
                nil)
        }
        
        
    }
    
    @objc func video(_ videoPath: String, didFinishSavingWithError error: Error?, contextInfo info: AnyObject) {
        let title = (error == nil) ? "Success" : "Error"
        let message = (error == nil) ? "Video was saved" : "Video failed to save"
        
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func openImgVideoPicker() {
        videoAndImageReview.sourceType = .savedPhotosAlbum
        videoAndImageReview.delegate = self
        videoAndImageReview.mediaTypes = ["public.movie"]
        present(videoAndImageReview, animated: true, completion: nil)
    }
    
    
    
    func videoAndImageReview(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        videoURL = info[.mediaURL] as? URL
        print("videoURL:\(String(describing: videoURL))")
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
    
    
    func showActionSheet()
    {
        let alert = UIAlertController(title: nil , message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Choose from Gallery", style: .default , handler:{ (UIAlertAction)in
            
            
            self.cameraPicked = "1"
            self.imagePickerController.sourceType = .savedPhotosAlbum
            self.imagePickerController.delegate = self
            self.imagePickerController.mediaTypes = ["public.movie"]
                    self.grayView.backgroundColor = .clear
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
    
    
    
    
    
    
    
    
    func decline(reason:String)
    {
        if Reach.isConnectedToNetwork()
        {
            let id = DEFAULTS.string(forKey: "user_id")!
            SVProgressHUD.show(withStatus: "Please Wait...")
            let baseurl = URL(string:BASE_URL+"order/"+jobIdString)!
            var parameters = Parameters()
            
            print("Decline Parameters \(baseurl)")
            parameters = ["advisorId":id, "userId":self.userId, "isCompleted":"3", "reply_details":reason]
            print("Decline  Parameters are \(parameters)")
            
            Alamofire.request(baseurl, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON{ (responseData) -> Void in
                if((responseData.result.value) != nil)
                {
                    SVProgressHUD.dismiss()
                    print("THese are advisor orders")
                    let a = JSON(responseData.result.value)
                    self.showPopupWithAction(msg: "Reply has been sent", sender: self)
                    
                    
                    
                }
                else
                {
                    SVProgressHUD.dismiss()
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
    


    
    
    
    func updateIsSeen()
    {
        if Reach.isConnectedToNetwork()
        {
            let baseurl = URL(string:BASE_URL+"updateOrderSeen/"+jobIdString+"?isSeen=1")!
            var parameters = Parameters()
            parameters = [:]
            print("Parameters are \(parameters)")
            Alamofire.request(baseurl, method: .post, parameters: parameters, encoding: URLEncoding.default).responseString{ (responseData) -> Void in
                if((responseData.result.value) != nil)
                {
                    print("THese are advisor orders")
                    let a = JSON(responseData.result.value)
                    print("Is Seen Updated Response")
                    print(a)
                }
                else
                {
                    SVProgressHUD.dismiss()
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

extension UIImage {
    func resizeImage(targetSize: CGSize) -> UIImage {
        let size = self.size
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        let newSize = widthRatio > heightRatio ?  CGSize(width: size.width * heightRatio, height: size.height * heightRatio) : CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    
    
    
    
}
