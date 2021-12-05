//
//  FavAdvisors.swift
//  Psychic
//
//  Created by APPLE on 1/11/19.
//  Copyright © 2019 Jobesk. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
import AVFoundation
import MediaPlayer
import AudioToolbox
import AVKit
import Nuke

class FavAdvisors: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, AVPlayerViewControllerDelegate, SWRevealViewControllerDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var menuBtn: UIButton!
    
 
   
    var allFeatured = JSON()
    var advisorID = String()
    var btn = UIButton()
    @IBOutlet weak var wingaMonh: UIImageView!
    @IBOutlet weak var wingaLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenu(sender: self, menuBtn: menuBtn)
        fetchFavAdvisors()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        if self.revealViewController() != nil
        {
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
        
        self.revealViewController()?.delegate = self
        let frame = self.view.frame
        btn.frame = frame
    }
    
    func revealController(_ revealController: SWRevealViewController!, didMoveTo position: FrontViewPosition) {
        
        switch position {
            
        case FrontViewPosition.leftSideMostRemoved:
            print("LeftSideMostRemoved")
            // Left most position, front view is presented left-offseted by rightViewRevealWidth+rigthViewRevealOverdraw
            
        case FrontViewPosition.leftSideMost:
            print("LeftSideMost")
            // Left position, front view is presented left-offseted by rightViewRevealWidth
            
        case FrontViewPosition.leftSide:
            print("LeftSide")
            
        // Center position, rear view is hidden behind front controller
        case FrontViewPosition.left:
            print("Left")
            //Closed
            //0 rotation
            btn.isHidden = true
            
            
        // Right possition, front view is presented right-offseted by rearViewRevealWidth
        case FrontViewPosition.right:
            print("Right")
            
            
            btn.isHidden = false
            btn.addTarget(self, action: #selector(self.pressButton(_:)), for: .touchUpInside)
            
            
            self.view.addSubview(btn)
            
            
            //Opened
            //rotated
            
            // Right most possition, front view is presented right-offseted by rearViewRevealWidth+rearViewRevealOverdraw
            
        case FrontViewPosition.rightMost:
            print("RightMost")
            // Front controller is removed from view. Animated transitioning from this state will cause the same
            // effect than animating from FrontViewPositionRightMost. Use this instead of FrontViewPositionRightMost when
            // you intent to remove the front controller view from the view hierarchy.
            
        case FrontViewPosition.rightMostRemoved:
            print("RightMostRemoved")
            
        }
        
    }
    
    @objc func pressButton(_ sender: UIButton){
        self.revealViewController().revealToggle(animated: true)
        print("\(sender)")
    }
    

    func fetchFavAdvisors()
    {
        if Reach.isConnectedToNetwork()
        {
            let id = DEFAULTS.string(forKey: "user_id")!
            SVProgressHUD.show(withStatus: "Please wait.....")
            let baseurl = URL(string:BASE_URL+"favourite?userId="+id)!
            var parameters = Parameters()
            
            
            parameters = [:]
            
            Alamofire.request(baseurl, method: .get, parameters: parameters, encoding: URLEncoding.default).responseJSON{ (responseData) -> Void in
                if((responseData.result.value) != nil)
                {
                    SVProgressHUD.dismiss()
                    
                    let a = JSON(responseData.result.value)
           
                    self.allFeatured = a["Result"]
                    
                    if self.allFeatured.count == 0
                    {
                        self.collectionView.isHidden = true
                        self.wingaMonh.isHidden = false
                        self.wingaLabel.isHidden = false
                        
                    }
                    else
                    {
                            self.collectionView.reloadData()
                    }
                    
                    
           
                    
                    
//                    self.performSegue(withIdentifier: "hhh", sender: self)
                    
                    
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
    
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return allFeatured.count
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "advisorsCell", for: indexPath) as! AdvisorCollectionCell
        
        
        cell.userName.text = "\(allFeatured[indexPath.row]["screenName"])"
        
        cell.insight.text = "\(allFeatured[indexPath.row]["serviceName"])"
        
        let img = "\(allFeatured[indexPath.row]["profileImage"])"
        let add = "\(IMAGE_BASE_URL)"+"\(img)"
        let url = URL(string: add)
        Nuke.loadImage(with: url!, into: cell.userImage)
        
        cell.userImage.clipsToBounds = true
        cell.userImage.layer.cornerRadius = 10
        
        cell.chatBtn.tag = indexPath.row
        cell.videoBtn.tag = indexPath.row
        cell.chatBtn.addTarget(self, action: #selector(chatBtnPressed(_:)), for: .touchUpInside)
        cell.videoBtn.addTarget(self, action: #selector(videoBtn(_:)), for: .touchUpInside)
        
        let stars = "\(allFeatured[indexPath.row]["rating"])"
        if "\(allFeatured[indexPath.row]["isOnline"])" == "0"
        {
            cell.onlineView.backgroundColor = .gray
        }
        else
        {
          cell.onlineView.backgroundColor = .green
        }
        print("Rating is \(stars)")
        let dbl = Double(stars)
        print("and other is \(dbl!)")
        let a = Int(dbl!)
        if a == 0
        {
            cell.oneStar.image = UIImage(named: "star")
            cell.twoStar.image = UIImage(named: "star")
            cell.threeStar.image = UIImage(named: "star")
            cell.fourStar.image = UIImage(named: "star")
            cell.fiveStar.image = UIImage(named: "star")
            
        } else if a == 1
        {
            cell.oneStar.image = UIImage(named: "filledStar")
            cell.twoStar.image = UIImage(named: "star")
            cell.threeStar.image = UIImage(named: "star")
            cell.fourStar.image = UIImage(named: "star")
            cell.fiveStar.image = UIImage(named: "star")
        } else if a == 2
        {
            cell.oneStar.image = UIImage(named: "filledStar")
            cell.twoStar.image = UIImage(named: "filledStar")
            cell.threeStar.image = UIImage(named: "star")
            cell.fourStar.image = UIImage(named: "star")
            cell.fiveStar.image = UIImage(named: "star")
            
        } else if a == 3
        {
            cell.oneStar.image = UIImage(named: "filledStar")
            cell.twoStar.image = UIImage(named: "filledStar")
            cell.threeStar.image = UIImage(named: "filledStar")
            cell.fourStar.image = UIImage(named: "star")
            cell.fiveStar.image = UIImage(named: "star")
            
        } else if a == 4
        {
            cell.oneStar.image = UIImage(named: "filledStar")
            cell.twoStar.image = UIImage(named: "filledStar")
            cell.threeStar.image = UIImage(named: "filledStar")
            cell.fourStar.image = UIImage(named: "filledStar")
            cell.fiveStar.image = UIImage(named: "star")
            
        } else if a == 5
        {
            cell.oneStar.image = UIImage(named: "filledStar")
            cell.twoStar.image = UIImage(named: "filledStar")
            cell.threeStar.image = UIImage(named: "filledStar")
            cell.fourStar.image = UIImage(named: "filledStar")
            cell.fiveStar.image = UIImage(named: "filledStar")
            
        }

        
        cell.contentView.layer.cornerRadius = 5.0
        cell.contentView.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        cell.contentView.layer.borderWidth = 1
        
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cell.layer.shadowRadius = 1.0
        cell.layer.shadowOpacity = 0.8
        cell.layer.masksToBounds = false
        
        //        serviceName
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        self.advisorID = "\(allFeatured[indexPath.row]["id"])"
        self.performSegue(withIdentifier: "det", sender: nil)
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "det"
        {
            let vc =  segue.destination as! ShowAdvisorDetails
            vc.advisorID = self.advisorID
            
            
        }
    }
    
    
    @objc func chatBtnPressed(_ sender: UIButton!)
    {
        print(sender.tag)
        self.advisorID = "\(sender.tag)"
        //            self.performSegue(withIdentifier: "oneChatttt", sender: nil)
    }
    
    
    @objc func videoBtn(_ sender: UIButton!)
    {
        
        let videoLink = "\(allFeatured[sender.tag]["profileVideo"])"
        let videoURL = URL(string: "\(BASE_URL)"+"\(videoLink)")
        let player = AVPlayer(url: videoURL!)
        let playervc = AVPlayerViewController()
        playervc.delegate = self
        playervc.player = player
        self.present(playervc, animated: true) {
            playervc.player!.play()
        }
        
        
    }

}
