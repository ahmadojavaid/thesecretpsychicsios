//
//  ShowAdvisorDetails.swift
//  Psychic
//
//  Created by APPLE on 1/9/19.
//  Copyright © 2019 Jobesk. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
import AVKit
import Nuke
import AVFoundation
import MediaPlayer
import AudioToolbox

class ShowAdv:UIViewController, UITableViewDelegate, UITableViewDataSource, AVPlayerViewControllerDelegate, SWRevealViewControllerDelegate {
    

    
    @IBOutlet weak var dotedImage: UIImageView!
    @IBOutlet weak var mm: UIImageView!
    @IBOutlet weak var shareView: UIView!
    @IBOutlet weak var advVideo: UIImageView!
    @IBOutlet weak var liveChatLabel: UILabel!
    @IBOutlet weak var videoLabel: UILabel!
    @IBOutlet weak var videoImage: UIImageView!
    @IBOutlet weak var chatImage: UIImageView!
    var rotataed = "1"
      var netImage1 = UIImage()
    //    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var menuDots: UIImageView!
    @IBOutlet weak var likeBack: UIView!
    var videoLink = String()
    
    var headerHeight = CGFloat()
    @IBOutlet weak var userProfileImage: UIImageView!
    
    var menuOpen = 0
    @IBOutlet weak var myView: UIView!
    
    
    @IBOutlet weak var headerView: UIView!
    var happy = 0
    var sad = 0
    var totol = 0
    var count = 0
    
    var videoAddress = String()
    @IBOutlet weak var menuHeight: NSLayoutConstraint!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var aboutMeData: UILabel!
    
    
    
    @IBOutlet weak var astarOne: UIImageView!
    @IBOutlet weak var astarTwo: UIImageView!
    @IBOutlet weak var astarThree: UIImageView!
    @IBOutlet weak var astarFour: UIImageView!
    @IBOutlet weak var astarFive: UIImageView!
    
    
    @IBOutlet weak var shareBtnRefrence: UIButton!
    @IBOutlet weak var starOne: UIImageView!
    @IBOutlet weak var starTwo: UIImageView!
    @IBOutlet weak var starThree: UIImageView!
    @IBOutlet weak var starFour: UIImageView!
    @IBOutlet weak var starFive: UIImageView!
    
    @IBOutlet weak var secondCategories: UILabel!
    
    @IBOutlet weak var aboutMeSecond: UILabel!
    @IBOutlet weak var menuUserName: UILabel!
    @IBOutlet weak var servicesDetails: UILabel!
    @IBOutlet weak var menuAboutMe: UILabel!
    @IBOutlet weak var aboutMyServicesLabel: UILabel!
    @IBOutlet weak var happyLabel1: UILabel!
    
    @IBOutlet weak var sadFace2: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var reviews = JSON()
    var btn = UIButton()
    var advisorID = DEFAULTS.string(forKey: "user_id")!
    
    @IBOutlet weak var blurView: UIView!
    let blurEffect = UIBlurEffect(style: .dark)
    var blurredEffectView = UIVisualEffectView()
    
    
    //    @IBOutlet weak var addtoFavBtn: UIButton!
    
    var fav = 0
    
    @IBOutlet weak var menuBtn: UIButton!
    var favuorited = String()
    
    
    @IBOutlet weak var mmmm: UIView!
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        sideMenu(sender: self, menuBtn: menuBTn)
        //        heightConstraint.constant = self.view.frame.height - 450
        blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = self.view.frame
        
    
        
        
        
        sideMenu(sender: self, menuBtn: menuBtn)
        getUerProfile()
        
        shareView.backgroundColor = myGrayColor
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.isNavigationBarHidden = true
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 80.0
        tableView.backgroundView = .none
        tableView.backgroundColor = .clear
        //        likeBack.backgroundColor = myGrayColor
        
        
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
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Dynamic sizing for the header view
        
        if  headerView == tableView.tableHeaderView {
            let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            var headerFrame = headerView.frame
            
            // If we don't have this check, viewDidLayoutSubviews() will get
            // repeatedly, causing the app to hang.
            if height != headerFrame.size.height {
                headerFrame.size.height = height
                headerView.frame = headerFrame
                tableView.tableHeaderView = headerView
                
                self.headerHeight = headerView.frame.height
                self.menuHeight.constant = self.view.frame.height - 350
                
                
                
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func getUerProfile()
    {
        if Reach.isConnectedToNetwork()
        {
            
            let id = advisorID
            SVProgressHUD.show(withStatus: "Getting your information")
            let baseurl = URL(string:BASE_URL+"showAdvisorInfo/"+id)!
            let clientid = DEFAULTS.string(forKey: "user_id")!
            var parameters = Parameters()
            parameters = ["userId":clientid]
            Alamofire.request(baseurl, method: .get, parameters: parameters, encoding: URLEncoding.default).responseJSON{ (responseData) -> Void in
                if((responseData.result.value) != nil)
                {
                    SVProgressHUD.dismiss()
                    let a = JSON(responseData.result.value)

                    let cats = a["Result"][0]["advisorscategories"]
                    var categoriesName = ""
                    for i in 0..<cats.count
                    {
                        let a = "\(cats[i]["categoryName"]),"
                        categoriesName += a
                    }
                    categoriesName = "\(categoriesName.dropLast())"
                    
                    self.secondCategories.text = categoriesName
                    self.menuAboutMe.text = "\(a["Result"][0]["aboutMe"])"
                    self.userName.text = "\(a["Result"][0]["screenName"])"
                    DEFAULTS.set("\(a["Result"][0]["screenName"])", forKey: "user_name")
                    self.menuUserName.text = "\(a["Result"][0]["serviceName"])"
                    
                    self.servicesDetails.text = "\(a["Result"][0]["aboutYourServices"])" 
                    
                    
                    let img = "\(a["Result"][0]["profileImage"])"
                    DEFAULTS.set(img, forKey:"user_image")
                    ADVISOR_IMAGE = img
                    ADVISOR_NAME = "\(a["Result"][0]["legalNameOfIndividual"])"
                    self.videoLink = "\(a["Result"][0]["profileVideo"])"
                    ADVISOR_ID = "\(a["Result"][0]["id"])"
                    let add = "\(IMAGE_BASE_URL)"+"\(img)"
                    let url = URL(string: add)
                    Nuke.loadImage(with: url!, into: self.userProfileImage)
                    self.userProfileImage.clipsToBounds = true
                    self.userProfileImage.contentMode = .scaleAspectFill
                    
                    
                    
                    self.reviews = a["Result"][0]["advisors_reviews"]
                    
                     self.videoAddress = "\(a["Result"][0]["profileVideo"])"
                    self.videoLink = self.videoAddress
                    
                    
                    print("Video Link is \(self.videoAddress)")
                    
                    
                    _ = DispatchQueue.global(qos: .userInteractive).async {

                        self.netImage1 = self.createThumbnailOfVideoFromRemoteUrl(url: "\(BASE_URL)\(self.videoAddress)")!

                        DispatchQueue.main.async {
                            self.advVideo.image = self.netImage1
//                            let size = CGSize(width: self.advVideo.frame.width, height: self.advVideo.frame.height)
//                            self.advVideo.image = self.advVideo.image!.resizeImage(targetSize: size)
                            self.advVideo.contentMode = .scaleAspectFill
                        }

                    }
                    
                    
                    
                    var total = Int()
                    
                    for i in 0..<self.reviews.count
                    {
                        let a = Int("\(self.reviews[i]["rating"])")
                        total = total + a!
                        
                        
                        let b = Int("\(a!)")!
                        if b <= 3
                        {
                            self.sad = self.sad + 1
                        }
                        else
                        {
                            self.happy = self.happy + 1
                        }
                        
                    }
                    
                    self.happyLabel1.text = "\(self.happy)"
                    //                    self.happyLabel2.text = "\(self.happy)"
                    //                    self.sadFace1.text = "\(self.sad)"
                    self.sadFace2.text = "\(self.sad)"
                    
                    if total != 0
                    {
                        let avg = total / self.reviews.count
                        
                        if avg == 0
                        {
                            self.astarOne.image = UIImage(named: "star")
                            self.astarTwo.image = UIImage(named: "star")
                            self.astarThree.image = UIImage(named: "star")
                            self.astarFour.image = UIImage(named: "star")
                            self.astarFive.image = UIImage(named: "star")
                            
                            self.starOne.image = UIImage(named: "star")
                            self.starTwo.image = UIImage(named: "star")
                            self.starThree.image = UIImage(named: "star")
                            self.starFour.image = UIImage(named: "star")
                            self.starFive.image = UIImage(named: "star")
                            
                        } else if avg == 1
                        {
                            self.astarOne.image = UIImage(named: "filledStar")
                            self.astarTwo.image = UIImage(named: "star")
                            self.astarThree.image = UIImage(named: "star")
                            self.astarFour.image = UIImage(named: "star")
                            self.astarFive.image = UIImage(named: "star")
                            
                            self.starOne.image = UIImage(named: "filledStar")
                            self.starTwo.image = UIImage(named: "star")
                            self.starThree.image = UIImage(named: "star")
                            self.starFour.image = UIImage(named: "star")
                            self.starFive.image = UIImage(named: "star")
                        } else if avg == 2
                        {
                            self.astarOne.image = UIImage(named: "filledStar")
                            self.astarTwo.image = UIImage(named: "filledStar")
                            self.astarThree.image = UIImage(named: "star")
                            self.astarFour.image = UIImage(named: "star")
                            self.astarFive.image = UIImage(named: "star")
                            
                            self.starOne.image = UIImage(named: "filledStar")
                            self.starTwo.image = UIImage(named: "filledStar")
                            self.starThree.image = UIImage(named: "filledStar")
                            self.starFour.image = UIImage(named: "star")
                            self.starFive.image = UIImage(named: "star")
                        } else if avg == 3
                        {
                            self.astarOne.image = UIImage(named: "filledStar")
                            self.astarTwo.image = UIImage(named: "filledStar")
                            self.astarThree.image = UIImage(named: "filledStar")
                            self.astarFour.image = UIImage(named: "star")
                            self.astarFive.image = UIImage(named: "star")
                            
                            
                            self.starOne.image = UIImage(named: "filledStar")
                            self.starTwo.image = UIImage(named: "filledStar")
                            self.starThree.image = UIImage(named: "filledStar")
                            self.starFour.image = UIImage(named: "star")
                            self.starFive.image = UIImage(named: "star")
                        } else if avg == 4
                        {
                            
                            self.astarOne.image = UIImage(named: "filledStar")
                            self.astarTwo.image = UIImage(named: "filledStar")
                            self.astarThree.image = UIImage(named: "filledStar")
                            self.astarFour.image = UIImage(named: "filledStar")
                            self.astarFive.image = UIImage(named: "star")
                            
                            
                            self.starOne.image = UIImage(named: "filledStar")
                            self.starTwo.image = UIImage(named: "filledStar")
                            self.starThree.image = UIImage(named: "filledStar")
                            self.starFour.image = UIImage(named: "filledStar")
                            self.starFive.image = UIImage(named: "star")
                        } else if avg == 5
                        {
                            self.astarOne.image = UIImage(named: "filledStar")
                            self.astarTwo.image = UIImage(named: "filledStar")
                            self.astarThree.image = UIImage(named: "filledStar")
                            self.astarFour.image = UIImage(named: "filledStar")
                            self.astarFive.image = UIImage(named: "filledStar")
                            self.starOne.image = UIImage(named: "filledStar")
                            self.starTwo.image = UIImage(named: "filledStar")
                            self.starThree.image = UIImage(named: "filledStar")
                            self.starFour.image = UIImage(named: "filledStar")
                            self.starFive.image = UIImage(named: "filledStar")
                        }
                    }
                    else
                    {
                        self.astarOne.image = UIImage(named: "star")
                        self.astarTwo.image = UIImage(named: "star")
                        self.astarThree.image = UIImage(named: "star")
                        self.astarFour.image = UIImage(named: "star")
                        self.astarFive.image = UIImage(named: "star")
                        
                        self.starOne.image = UIImage(named: "star")
                        self.starTwo.image = UIImage(named: "star")
                        self.starThree.image = UIImage(named: "star")
                        self.starFour.image = UIImage(named: "star")
                        self.starFive.image = UIImage(named: "star")
                        
                    }
                    
                    //                    self.favuorited = "\(a["Result"][0]["favuorited"])"
                    //                    if self.favuorited == "0"
                    //                    {
                    //                        self.likeBack.backgroundColor =  myGrayColor
                    //                    }
                    //                    else
                    //                    {
                    //                        self.likeBack.backgroundColor = myRedColor
                    //                    }
                    //
                    self.tableView.reloadData()
                    
                    print("Data of one Advisor")
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
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reviewCell") as! ReviewCell
        
        
        let text = "\(self.reviews[indexPath.row]["updated_at"])"
        
        
        let range: Range<String.Index> = text.range(of: " ")!
        let index: Int = text.distance(from: text.startIndex, to: range.lowerBound)
        let dateonly = text.prefix(index)
        
        
        let dateFormatter = DateFormatter()
        
        
        
        let dateString = "\(dateonly)" // change to your date format
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: dateString)
        dateFormatter.dateStyle = .medium
        let goodDate = dateFormatter.string(from: date!)
        cell.dateLabel.text = "\(goodDate)"
        
        cell.reviewDetails.text = "\(self.reviews[indexPath.row]["feedback"])"
        cell.userName.text = "\(self.reviews[indexPath.row]["name"])"
        let stars = "\(self.reviews[indexPath.row]["rating"])"
        
        
        print("FeedBack is \(self.reviews[indexPath.row]["feedback"])")
        
        if stars == "1"
        {
            cell.oneStar.image = UIImage(named: "filledStar")
            cell.twoStar.image = UIImage(named: "star")
            cell.threeStar.image = UIImage(named: "star")
            cell.fourStar.image = UIImage(named: "star")
            cell.fiveStar.image = UIImage(named: "star")
        } else if stars == "2"
        {
            cell.oneStar.image = UIImage(named: "filledStar")
            cell.twoStar.image = UIImage(named: "filledStar")
            cell.threeStar.image = UIImage(named: "star")
            cell.fourStar.image = UIImage(named: "star")
            cell.fiveStar.image = UIImage(named: "star")
        } else if stars == "3"
        {
            cell.oneStar.image = UIImage(named: "filledStar")
            cell.twoStar.image = UIImage(named: "filledStar")
            cell.threeStar.image = UIImage(named: "filledStar")
            cell.fourStar.image = UIImage(named: "star")
            cell.fiveStar.image = UIImage(named: "star")
        } else if stars == "4"
        {
            cell.oneStar.image = UIImage(named: "filledStar")
            cell.twoStar.image = UIImage(named: "filledStar")
            cell.threeStar.image = UIImage(named: "filledStar")
            cell.fourStar.image = UIImage(named: "filledStar")
            cell.fiveStar.image = UIImage(named: "star")
        } else if stars == "5"
        {
            cell.oneStar.image = UIImage(named: "filledStar")
            cell.twoStar.image = UIImage(named: "filledStar")
            cell.threeStar.image = UIImage(named: "filledStar")
            cell.fourStar.image = UIImage(named: "filledStar")
            cell.fiveStar.image = UIImage(named: "filledStar")
        }
        cell.selectionStyle = .none
        cell.setNeedsUpdateConstraints()
        cell.updateConstraintsIfNeeded()
        
        return cell
    }
    
    @IBAction func backBTn(_ sender: Any)
    {
        DispatchQueue.main.async
            {
                self.navigationController?.popViewController(animated: true)
                self.performSegue(withIdentifier: "backHome", sender: self)
        }
        
    }
    
    
    @IBAction func shareBtn(_ sender: Any)
    {
        self.myView.addSubview(blurredEffectView)
        blurView.isHidden = false
    }
    
    @IBAction func menuHide(_ sender: Any)
    {
        blurredEffectView.removeFromSuperview()
        blurView.isHidden = true
    }
    
    
    
    @IBAction func addToFavrite(_ sender: Any)
    {
        addToFav()
        blurredEffectView.removeFromSuperview()
        blurView.isHidden = true
    }
    
    
    
    
    func addToFav()
    {
        if Reach.isConnectedToNetwork()
        {
            if likeBack.backgroundColor == myGrayColor
            {
                addToFavAgain()
                likeBack.backgroundColor = myRedColor
            } else if likeBack.backgroundColor == myRedColor
            {
                likeBack.backgroundColor = myGrayColor
                removeFav()
            }
        }
        else
        {
            showPopup(msg: "Could not conenct to Internet", sender: self)
        }
    }
    
    
    
    
    func addToFavAgain()
    {
        
        
        let id = DEFAULTS.string(forKey: "user_id")!
        SVProgressHUD.show(withStatus: "Adding to favorite....")
        let baseurl = URL(string:BASE_URL+"favourite")!
        var parameters = Parameters()
        parameters = ["userId":id, "advisorId":advisorID]
        Alamofire.request(baseurl, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON{ (responseData) -> Void in
            if((responseData.result.value) != nil)
            {
                SVProgressHUD.dismiss()
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
    
    
    func removeFav()
    {
        let id = DEFAULTS.string(forKey: "user_id")!
        SVProgressHUD.show(withStatus: "Removing favorite....")
        let baseurl = URL(string:BASE_URL+"delfavourite")!
        var parameters = Parameters()
        parameters = ["userId":id, "advisorId":advisorID]
        Alamofire.request(baseurl, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON{ (responseData) -> Void in
            if((responseData.result.value) != nil)
            {
                SVProgressHUD.dismiss()
                let a = JSON(responseData.result.value)
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
    
    
    @IBAction func chatBtnPresed(_ sender: Any)
    {
        performSegue(withIdentifier: "detailChat", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "detailChat"
        {
            let vc = segue.destination as! OneChat
            vc.senderId = advisorID
            vc.from = "advisorDetails"
        }
    }
    

    @IBAction func backBtn(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    

    
    
    
    @IBAction func playBtn(_ sender: Any)
    {
        vidoePlay(videoLink:self.videoLink)
    }
    
    func vidoePlay(videoLink:String)
    {
        print("Iam in second screen \(videoLink)")
        
        let videoURL = URL(string: "\(BASE_URL)"+"\(videoLink)")
        let player = AVPlayer(url: videoURL!)
        let playervc = AVPlayerViewController()
        playervc.delegate = self
        playervc.player = player
        self.present(playervc, animated: true) {
            playervc.player!.play()
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let contentOffset = scrollView.contentOffset.y
        if contentOffset > 100
        {
            mm.image = UIImage(named: "blueShare")
            mm.isUserInteractionEnabled = true
        }
        else
        {
            mm.image = UIImage(named: "dark")
            mm.isUserInteractionEnabled = false

        }
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//
//        let contentOffset = scrollView.contentOffset.y
//
//        if contentOffset > 100
//        {
//            if rotataed == "1"
//            {
//                let rotation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
//                rotation.toValue = Double.pi
//                rotation.duration = 0.25 // or however long you want ...
//                rotation.isCumulative = true
//                rotation.repeatCount = 1
//                mm.layer.add(rotation, forKey: "rotationAnimation")
//                rotataed = "2"
//            }
//
//            shareView.backgroundColor = myBlueColor
//        }
//        else
//        {
//
//            if rotataed == "2"
//            {
//                let rotation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
//                rotation.toValue = Double.pi / 2
//                rotation.duration = 0.25 // or however long you want ...
//                rotation.isCumulative = true
//                rotation.repeatCount = 1
//                rotation.fillMode = CAMediaTimingFillMode.forwards
//                rotation.isRemovedOnCompletion = false
//                mm.layer.add(rotation, forKey: "rotationAnimation")
//                rotataed = "1"
//            }
//            shareView.backgroundColor = myGrayColor
//        }
//
//    }
    
    
    @IBAction func socialShareButton(_ sender: Any)
    {
        
        let username = DEFAULTS.string(forKey: "username")!
        let wholeAddress = "\(BASE_URL)profileLink?userName=\(username)"
        let items = [wholeAddress]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
        
    }
    
    
    
    @IBAction func advHome(segue: UIStoryboardSegue)
    {
        
        
    }
    
}




extension UIImage {
    func rotate(radians: Float) -> UIImage? {
        var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
        // Trim off the extremely small float value to prevent core graphics from rounding it up
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!
        
        // Move origin to middle
        context.translateBy(x: newSize.width/2, y: newSize.height/2)
        // Rotate around middle
        context.rotate(by: CGFloat(radians))
        // Draw the image at its center
        self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

