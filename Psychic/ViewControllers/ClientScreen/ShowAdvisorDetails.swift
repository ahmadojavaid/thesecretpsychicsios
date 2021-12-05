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


class ShowAdvisorDetails:UIViewController, UITableViewDelegate, UITableViewDataSource, AVPlayerViewControllerDelegate {
    
    @IBOutlet weak var chatBtn: UIButton!
    @IBOutlet weak var dotedImage: UIImageView!
    @IBOutlet weak var videoBtn: UIButton!
    @IBOutlet weak var shareView: UIView!
    
    @IBOutlet weak var shareBtnRefrence: UIButton!
    @IBOutlet weak var liveChatText: UILabel!
    @IBOutlet weak var advVideo: UIImageView!
    
    var textChatRate = ""
    var sharename = String()
    var rotate = 0
    @IBOutlet weak var liveChatLabel: UILabel!
    @IBOutlet weak var videoLabel: UILabel!
    @IBOutlet weak var videoImage: UIImageView!
    @IBOutlet weak var chatImage: UIImageView!
    var  videoAddress = String()
    var netImage1 = UIImage()
//    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var likeBack: UIView!
    
    var headerHeight = CGFloat()
    @IBOutlet weak var userProfileImage: UIImageView!
    
    var menuOpen = 0
    @IBOutlet weak var myView: UIView!
    

    @IBOutlet weak var headerView: UIView!
    var happy = 0
    var sad = 0
    var totol = 0
    var count = 0
    
    var videoLink = String()
    var profileImageString = String()
    
    
    @IBOutlet weak var menuHeight: NSLayoutConstraint!
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var aboutMeData: UILabel!
    @IBOutlet weak var starOne: UIImageView!
    @IBOutlet weak var starTwo: UIImageView!
    @IBOutlet weak var starThree: UIImageView!
    @IBOutlet weak var starFour: UIImageView!
    @IBOutlet weak var starFive: UIImageView!
    
    
    
    @IBOutlet weak var astarOne: UIImageView!
    @IBOutlet weak var astarTwo: UIImageView!
    @IBOutlet weak var astarThree: UIImageView!
    @IBOutlet weak var astarFour: UIImageView!
    @IBOutlet weak var astarFive: UIImageView!
    
    @IBOutlet weak var secondCategories: UILabel!
    
    @IBOutlet weak var aboutMeSecond: UILabel!
    @IBOutlet weak var menuUserName: UILabel!
    @IBOutlet weak var servicesDetails: UILabel!
    @IBOutlet weak var menuAboutMe: UILabel!
    @IBOutlet weak var aboutMyServicesLabel: UILabel!
    @IBOutlet weak var happyLabel1: UILabel!

    @IBOutlet weak var sadFace2: UILabel!

    @IBOutlet weak var tableView: UITableView!
    
    var userNameString = String()
    var reviews = JSON()
    
    var advisorID = String()
    var type = String()
    
    @IBOutlet weak var blurView: UIView!
    let blurEffect = UIBlurEffect(style: .dark)
    var blurredEffectView = UIVisualEffectView()
    
    
//    @IBOutlet weak var addtoFavBtn: UIButton!
    
    var fav = 0
    
    var favuorited = String()
    
    
    @IBOutlet weak var mmmm: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        sideMenu(sender: self, menuBtn: menuBTn)
//        heightConstraint.constant = self.view.frame.height - 450
        blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = self.view.frame
        
        shareView.backgroundColor = myGrayColor
        getUerProfile()
        print("Advisor jhlk jhklj h\(advisorID)")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 80.0
        tableView.backgroundView = .none
        tableView.backgroundColor = .clear
        likeBack.backgroundColor = myGrayColor
        
        
        if self.revealViewController() != nil
        {
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
        
        
   
        
    }
    
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // Dynamic sizing for the header view


        if  headerView == tableView.tableHeaderView {
            let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            var headerFrame = headerView.frame

            // If we don't have this check, viewDidLayoutSubviews() will get
            // repeatedly, causing the app to hang.
            if height != headerFrame.size.height
            {
                headerFrame.size.height = height
                headerView.frame = headerFrame
                tableView.tableHeaderView = headerView
                self.headerHeight = headerView.frame.height
                self.menuHeight.constant = self.view.frame.height - 300
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
                    var services = ""
                    for i in 0..<cats.count
                    {
                        let a = "\(cats[i]["categoryName"]),"
                        services += a
                    }
                    services = "\(services.dropLast())"
                    self.secondCategories.text = services
                    self.servicesDetails.text =  "\(a["Result"][0]["aboutYourServices"])"
                    self.userNameString  = "\(a["Result"][0]["screenName"])"
                    self.menuAboutMe.text = "\(a["Result"][0]["aboutMe"])"
                    self.userName.text = "\(a["Result"][0]["screenName"])"
                    self.menuUserName.text = "\(a["Result"][0]["serviceName"])"
                    self.sharename = "\(a["Result"][0]["username"])"
                    
                    self.textChatRate = "\(a["Result"][0]["TextChatRate"])"
                    
                    self.liveChatText.text = "Start a live text chat with this advisor. \nYou will be charged £\("\(a["Result"][0]["TextChatRate"])") per 160 characters"
                    if "\(a["Result"][0]["liveChat"])" == "0"
                    {
                        self.chatBtn.isHidden = true
                        self.liveChatLabel.textColor = .gray
                        self.chatImage.image = UIImage(named: "gray_chat")
                    }

                     if "\(a["Result"][0]["threeMinuteVideo"])" == "0"
                     {
                        self.videoBtn.isHidden = true
                        self.videoLabel.textColor = .gray
                        self.videoImage.image = UIImage(named: "gray_video")

                    }
                    let img = "\(a["Result"][0]["profileImage"])"
                    ADVISOR_IMAGE = img
                    ADVISOR_NAME = "\(a["Result"][0]["screenName"])"
                    ADVISOR_ID = "\(a["Result"][0]["id"])"
                    let add = "\(IMAGE_BASE_URL)"+"\(img)"
                    let url = URL(string: add)
                    Nuke.loadImage(with: url!, into: self.userProfileImage)
                    self.profileImageString = img
                    
                    
                    self.reviews = a["Result"][0]["advisors_reviews"]
                    
                    
                    
                    
                    self.videoAddress = "\(a["Result"][0]["profileVideo"])"
                    self.videoLink = self.videoAddress
                    
                    _ = DispatchQueue.global(qos: .userInteractive).async {
                        let path = URL(string:"\(BASE_URL)"+"\(self.videoAddress)")
                        self.netImage1 = self.getThumbnailFrom(path: path!)!
                        
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
                            self.starThree.image = UIImage(named: "star")
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

                    
                    self.favuorited = "\(a["Result"][0]["favuorited"])"
                    if self.favuorited == "0"
                    {
                        self.likeBack.backgroundColor =  myGrayColor
                    }
                    else
                    {
                        self.likeBack.backgroundColor = myRedColor
                    }

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
        cell.dateLabel.text = "\(dateonly)"
        
        
        
        

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



        cell.setNeedsUpdateConstraints()
        cell.updateConstraintsIfNeeded()
        cell.selectionStyle = .none
        
        
        
        
        return cell
}

    @IBAction func backBTn(_ sender: Any)
    {
        
                self.navigationController?.popViewController(animated: true)
                self.performSegue(withIdentifier: "backHome", sender: self)
                
        
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
                self.blurView.isHidden = true
                
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
                vc.sentTo = advisorID
                vc.from = "advisorDetails"
                vc.chatRate = textChatRate
                vc.userNameString = userNameString
                vc.profileImageString = "\(IMAGE_BASE_URL)"+profileImageString
        }
    }

    
    @IBAction func backBtn(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    @IBAction func advisorInfoScreen(segue: UIStoryboardSegue) {
        
    }
    
    
    
    
    
    
    
    func getThumbnailFrom(path: URL) -> UIImage? {
        
        do {
            
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
    
    
    
    

    
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//
//
//    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let contentOffset = scrollView.contentOffset.y
            if contentOffset > 100
            {
                dotedImage.image = UIImage(named: "clientBlue")
                shareBtnRefrence.isUserInteractionEnabled = true
            }
            else
            {
                dotedImage.image = UIImage(named: "clientDark")
                shareBtnRefrence.isUserInteractionEnabled = false
            }
    }
    
    
    
    @IBAction func socialShareButton(_ sender: Any)
    {
        
        
        let wholeAddress = "\(BASE_URL)profileLink?userName=\(self.sharename)"
        let items = [wholeAddress]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
        
    }
    @IBAction func blurTap(_ sender: Any)
    {
        blurredEffectView.removeFromSuperview()
        blurView.isHidden = true
    }
}


