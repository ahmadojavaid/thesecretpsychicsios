//
//  OrderDetails.swift
//  Psychic
//
//  Created by APPLE on 1/14/19.
//  Copyright © 2019 Jobesk. All rights reserved.
//
import UIKit
import AVFoundation
import SVProgressHUD
import SwiftyJSON
import Alamofire
import AVKit
import Nuke
import AVFoundation
import MediaPlayer
import AudioToolbox

class OrderDetails: UIViewController, AVPlayerViewControllerDelegate {

    
    
    // order Variables
    
    @IBOutlet weak var imgBack: UIView!
    @IBOutlet weak var conterLabel: UILabel!
    @IBOutlet weak var counterBack: UIView!
    @IBOutlet weak var rejectingReasone: UILabel!
    @IBOutlet weak var replyDetails: UILabel!
    @IBOutlet weak var scrolTop: NSLayoutConstraint!
    @IBOutlet weak var orderVideoHeight: NSLayoutConstraint!
    @IBOutlet weak var questionHead: UILabel!
    @IBOutlet weak var reviewViewHeight: NSLayoutConstraint!
    @IBOutlet weak var orderVieoView: UIView!

    @IBOutlet weak var titleOrderLabel: UILabel!
    @IBOutlet weak var orderStatus: UILabel!
    // reply variables
    
    @IBOutlet weak var commentUpper: NSLayoutConstraint!
    var replyVideo = String()
    var replyCommects = String()
    
    var oneOrder = oneItem
    
    @IBOutlet weak var orderVIdeoView: UIView!
    
    
    
    // order Outlets
    @IBOutlet weak var questionD: UILabel!
    @IBOutlet weak var advisorImage: UIImageView!
    @IBOutlet weak var advisorName: UILabel!
    @IBOutlet weak var preViewImage: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    
    
    
    // reply outlets
    
    @IBOutlet weak var replyImage: UIImageView!
    @IBOutlet weak var containViewConstraint: NSLayoutConstraint!
    
    
    
    
    @IBOutlet weak var replyView: UIView!
    
    // isSeem issues
    @IBOutlet weak var reviewVIew: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var orderView: UIView!
    @IBOutlet weak var containerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var chatBTn: UIView!
    @IBOutlet weak var replyVideoView: UIView!
    @IBOutlet weak var noResponseText: UILabel!
    @IBOutlet weak var greenView: UIView!
    @IBOutlet weak var secondDetails: UITextView!
    @IBOutlet weak var declineView: UIView!
    
    private let refreshControl = UIRefreshControl()
    @IBOutlet weak var orderViewHeight: NSLayoutConstraint!
    
    
    var counting = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        conterLabel.text = counting
        
        
        let a = "\(IMAGE_BASE_URL)"+"\(oneOrder["advisorImage"])"
        let url = URL(string: a)
        Nuke.loadImage(with: url!, into: advisorImage)
        advisorName.text = "\(oneOrder["screenName"])"
        let utc = "\(oneOrder["updated_at"])"
        let local = utc.fromUTCToLocalDateTime()
        let time = timeInterval(timeAgo: local)
        timeLabel.text  = time
        questionHead.text = "\(oneOrder["order_heading"])"
        advisorImage.clipsToBounds = true
        advisorImage.layer.cornerRadius = 21
        titleOrderLabel.text = "\(oneOrder["screenName"])"
         questionD.text =  "\(oneOrder["order_details"])"
        DispatchQueue.global().async {
            let url = URL(string: "\(BASE_URL)\(self.oneOrder["order_video"])")
            let asset = AVAsset(url: url!)
            let assetImgGenerate : AVAssetImageGenerator = AVAssetImageGenerator(asset: asset)
            assetImgGenerate.appliesPreferredTrackTransform = true
            let time = CMTimeMake(value: 1, timescale: 2)
            let img = try? assetImgGenerate.copyCGImage(at: time, actualTime: nil)
            if img != nil {
                let frameImg  = UIImage(cgImage: img!)
                DispatchQueue.main.async(execute: {
                    self.preViewImage.image = frameImg
                })
            }
        }
        
        
        DispatchQueue.global().async {
            let url = URL(string: "\(BASE_URL)\(self.oneOrder["reply_Video"])")
            let asset = AVAsset(url: url!)
            let assetImgGenerate : AVAssetImageGenerator = AVAssetImageGenerator(asset: asset)
            assetImgGenerate.appliesPreferredTrackTransform = true
            let time = CMTimeMake(value: 1, timescale: 2)
            let img = try? assetImgGenerate.copyCGImage(at: time, actualTime: nil)
            if img != nil {
                let frameImg  = UIImage(cgImage: img!)
                DispatchQueue.main.async(execute: {
                    self.replyImage.image = frameImg
                })
            }
        }
        
        


        if "\(oneOrder["order_video"])" == "0"
        {
            orderVideoHeight.constant = 0
            orderVieoView.isHidden = true
            
        }
        
        
        
        if "\(oneOrder["reply_Video"])" == "0"
        {
            commentUpper.constant = -190
            replyVideoView.isHidden = true
            
        }
        
        
        

        print("One Order ")
        print(oneOrder)
        
        if "\(oneOrder["isReviewed"])"  == "0"
        {
            print("I m here")
            reviewViewHeight.constant = 60
            reviewVIew.isHidden =  false
        }
        else
        {
            reviewVIew.isHidden =  true
            reviewViewHeight.constant = 0.0
        }
        
        if "\(oneOrder["isCompleted"])" == "1"
        {
            imgBack.backgroundColor = myGreenColor
            counterBack.backgroundColor = myGreenColor
            greenView.backgroundColor = myGreenColor
            noResponseText.isHidden = true
            replyDetails.text =  "\(oneOrder["reply_details"])"
//            reviewVIew.isHidden = true

        }
        else if "\(oneOrder["isCompleted"])" == "3"
        {
            imgBack.backgroundColor = myRedColor
            counterBack.backgroundColor = myRedColor
            greenView.backgroundColor = myRedColor
            reviewViewHeight.constant = 0.0
            orderStatus.text = "Order Declinced"
            declineView.isHidden = false
            replyView.visibility = .gone
            replyView.isHidden = true
            declineView.isHidden = false
            declineView.backgroundColor = myRedColor
            chatBTn.isHidden = true
            reviewViewHeight.constant = 0.0
            reviewVIew.isHidden =  true
            rejectingReasone.text = "\(oneOrder["reply_details"])"


        } else if "\(oneOrder["isCompleted"])" == "0"
        {
            imgBack.backgroundColor = myBlueColor
            greenView.backgroundColor = myBlueColor
            replyView.visibility = .gone
            replyView.isHidden = true
            chatBTn.isHidden = true
            counterBack.backgroundColor = myBlueColor
           reviewViewHeight.constant = 0.0
            reviewVIew.isHidden =  true
            
        }

        

    }
    
    
    
    
    
    
    
    
    
    @IBAction func gotoProfile(_ sender: Any)
    {
        let storyboard = UIStoryboard(name: "ClientScreens", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ShowAdvisorDetails") as! ShowAdvisorDetails
            vc.advisorID = "\(oneOrder["advisorId"])"
        navigationController?.pushViewController(vc, animated: true)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    @IBAction func videoPlayBtn(_ sender: Any)
    {
        let videoURL = URL(string: "\(BASE_URL)"+"\(self.oneOrder["order_video"])")
        let player = AVPlayer(url: videoURL!)
        let playervc = AVPlayerViewController()
        playervc.delegate = self
        playervc.player = player
        self.present(playervc, animated: true) {
            playervc.player!.play()
        }
    }
    
    
    @IBAction func replyVideoPlayBtn(_ sender: Any)
    {
        
        let videoURL = URL(string: "\(BASE_URL)"+"\(self.oneOrder["reply_Video"])")
        let player = AVPlayer(url: videoURL!)
        let playervc = AVPlayerViewController()
        playervc.delegate = self
        playervc.player = player
        self.present(playervc, animated: true) {
            playervc.player!.play()
        }
    }
    
    


    func getThumbnailFrom(path: URL) -> UIImage? {
        
        do
        {
            
            let asset = AVURLAsset(url: path , options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            return thumbnail
        } catch let error
        {
            
            print("*** Error generating thumbnail: \(error.localizedDescription)")
            return UIImage(named:"no-video")
            
        }
        
    }
    
    

    
    @IBAction func chatBtn(_ sender: Any)
    {
        self.performSegue(withIdentifier: "chatScreen", sender: nil)
    }
    
    @IBAction func reviewBtnPressed(_ sender: Any)
    {
        self.performSegue(withIdentifier: "reviewAdvisor", sender: nil)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "reviewAdvisor"
        {
//            advisorId
            let vc = segue.destination as! ReviewAdvisor
                vc.advisorId = "\(self.oneOrder["advisorId"])"
                vc.orderId = "\(self.oneOrder["id"])"
            
        } else if segue.identifier == "chatScreen"
        {
            let vc = segue.destination as! OneChat
                vc.from = "order"
                vc.sentTo = "\(self.oneOrder["advisorId"])"
                vc.chatRate = "\(self.oneOrder["TextChatRate"])"
                vc.profileImageString = "\(self.oneOrder["advisorImage"])"
                vc.userNameString = "\(self.oneOrder["screenName"])"
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    @IBAction func oneOrderScreen(segue: UIStoryboardSegue) {
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}


extension UIView {
    
    func visiblity(gone: Bool, dimension: CGFloat = 0.0, attribute: NSLayoutConstraint.Attribute = .height) -> Void {
        if let constraint = (self.constraints.filter{$0.firstAttribute == attribute}.first) {
            constraint.constant = gone ? 0.0 : dimension
            self.layoutIfNeeded()
            self.isHidden = gone
        }
    }
}





extension UIView {
    
    enum Visibility {
        case visible
        case invisible
        case gone
    }
    
    var visibility: Visibility {
        get {
            let constraint = (self.constraints.filter{$0.firstAttribute == .height && $0.constant == 0}.first)
            if let constraint = constraint, constraint.isActive {
                return .gone
            } else {
                return self.isHidden ? .invisible : .visible
            }
        }
        set {
            if self.visibility != newValue {
                self.setVisibility(newValue)
            }
        }
    }
    
    private func setVisibility(_ visibility: Visibility) {
        let constraint = (self.constraints.filter{$0.firstAttribute == .height && $0.constant == 0}.first)
        
        switch visibility {
        case .visible:
            constraint?.isActive = false
            self.isHidden = false
            break
        case .invisible:
            constraint?.isActive = false
            self.isHidden = true
            break
        case .gone:
            if let constraint = constraint {
                constraint.isActive = true
            } else {
                let constraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 0)
                self.addConstraint(constraint)
                constraint.isActive = true
            }
        }
    }
}
