//
//  ClientHomeScreen.swift
//  Psychic
//
//  Created by APPLE on 1/7/19.
//  Copyright © 2019 Jobesk. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SVProgressHUD
import Nuke
import RangeSeekSlider
import AVFoundation
import MediaPlayer
import AudioToolbox
import AVKit
import TTRangeSlider.TTRangeSliderDelegate

class ClientHomeScreen: UIViewController,UIPageViewControllerDataSource,  UIPageViewControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, RangeSeekSliderDelegate, AVPlayerViewControllerDelegate, videoPlayBtnDelegate, TTRangeSliderDelegate, SWRevealViewControllerDelegate
{
    
    
    func closeFriendsTapped(at index: String)
    {
        print("Iam in second screen \(index)")
        
        let videoURL = URL(string: "\(BASE_URL)"+"\(index)")
        let player = AVPlayer(url: videoURL!)
        let playervc = AVPlayerViewController()
        playervc.delegate = self
        playervc.player = player
        self.present(playervc, animated: true) {
            playervc.player!.play()
        }
    }
    
    var firstValue = 0
    var currentPage = 1
    var sortTotalPages = Int()
    var high = Int()
    var sortNib = SortNib()
    var filterView = FilterView()
    var sortValue = String()
    
    var lowerReview = Int()
    var higherReview = Int()
    var btn = UIButton()
    
    @IBOutlet weak var secondCollectionView: UICollectionView!
    @IBOutlet weak var headerTable: UIView!
    
    @IBOutlet weak var tableViewAdvisors: UITableView!
    
    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var menyBTn: UIButton!
    var pagecount =  UIPageControl()
    
    var api_type = "normal"
    
    
    var onlineValue = String()
    var reviewValues = String()
    var upperValues = Double()
    var lowerValues = Double()
    
    var advisorID = String()
    var sortPageCount = 1
    var refresher:UIRefreshControl!
    
    
    let blurEffect = UIBlurEffect(style: .dark)
    var blurredEffectView = UIVisualEffectView()
    
    
    
    @IBOutlet weak var menuBtn: UIButton!
    
    var advisors = [ListOfAdvisors]()
    
    var pageViewController = UIPageViewController()
    
    var array = [AdvisorList]()
    
    lazy var viewContollers : [AdvisorList] = {
        let sb = UIStoryboard(name: "ClientScreens", bundle: nil)
        for i in 0..<advisors.count
        {
            let vc1 = sb.instantiateViewController(withIdentifier: "AdvisorList") as! AdvisorList
            array.append(vc1)
        }
        return array
    } ()
    
    private let refreshControl = UIRefreshControl()
    
    
    
    fileprivate func intialSetup() {
        sideMenu(sender: self, menuBtn: menuBtn)
        
        refreshControl.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)
        
        
        if self.revealViewController() != nil
        {
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
        
        
        secondCollectionView.delegate = self
        secondCollectionView.dataSource = self
        
        
        
        
        let sb = UIStoryboard(name: "ClientScreens", bundle: nil)
        self.pageViewController = sb.instantiateViewController(withIdentifier: "advisors") as! UIPageViewController
        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self
        advisors = DB_Handler.getFeatured()!
        if advisors.count == 0
        {
            showPopup(msg: "No Featured Advisor Found, please try later", sender: self)
        }
        else
        {
            let a = advisors[0]
            print("\(IMAGE_BASE_URL)"+a.ad_image!)
            
            
            
            for i in 0..<advisors.count
            {
                print("These are Stars"+"\(advisors[i].ad_stars)")
            }
            
            
            
            
            if let firtVC = viewContollers.first
            {
                let a = advisors[0]
                firtVC.abc = "\(IMAGE_BASE_URL)"+a.ad_image!
                firtVC.desc = a.ad_desc!
                firtVC.userName = a.ad_name!
                firtVC.rating = a.ad_stars!
                print("VIdeo link is \(a.ad_video!)")
                firtVC.ad_video = a.ad_video!
                firtVC.delegate = self
                firtVC.isOnline = a.isOnline!
                firtVC.liveChat = a.liveChat!
                firtVC.advisorId = a.ad_id!
                firtVC.threeMinuteVideo = a.threeMinuteVideo!
                firtVC.advisorId = a.ad_id!
                print("Frist Name is \(a.ad_name!)")
                print("First User Id is \(a.ad_id!)")
                print("STars are \(a.ad_stars!)")
                
                pageViewController.setViewControllers([firtVC], direction: UIPageViewController.NavigationDirection.forward, animated: true, completion: nil)
            }
            //            pageViewController.view.frame = self.pgg.bounds
            pagecount.numberOfPages = advisors.count
            pagecount.currentPage = 0
            //            self.pgg.addSubview(pageViewController.view)
            
            
            
            
            
            
            
            
        }
        
        
        
        
        
        
    }
    
    //    override func viewDidLayoutSubviews()
    //    {
    //        pageViewController.view.frame = self.headerTable.bounds
    //        self.headerTable.addSubview(pageViewController.view)
    //        self.tableViewAdvisors.tableHeaderView = self.headerTable
    //        self.tableViewAdvisors.rowHeight = 200
    //
    //        tableViewAdvisors.backgroundColor = .clear
    //        tableViewAdvisors.backgroundView = .none
    //
    //
    //
    //    }
    
    
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if self.revealViewController() != nil
        {
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
        
        
        
        
        
        intialSetup()
        
        blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = self.view.frame
        
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
    
    @objc private func refreshWeatherData(_ sender: Any)
    {
        // Fetch Weather Data
        fetchAdvisors(page: "1")
        
    }
    
    @objc func languageScreen()
    {
        let storyboard = UIStoryboard(name: "ClientScreens", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ClientLanguageSelector") as! ClientLanguageSelector
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
    {
        
        guard let vcIndex = viewContollers.index(of: viewController as! AdvisorList) else { return nil }
        
        pagecount.currentPage = vcIndex
        
        let previeusIndex = vcIndex - 1
        
        guard previeusIndex >= 0 else {return nil}
        guard viewContollers.count > previeusIndex else {return nil}
        viewContollers[previeusIndex].abc = "\(IMAGE_BASE_URL)"+advisors[previeusIndex].ad_image!
        viewContollers[previeusIndex].desc = advisors[previeusIndex].ad_desc!
        viewContollers[previeusIndex].userName = advisors[previeusIndex].ad_name!
        viewContollers[previeusIndex].rating = advisors[previeusIndex].ad_stars!
        viewContollers[previeusIndex].advisorId = advisors[previeusIndex].ad_id!
        viewContollers[previeusIndex].ad_video = advisors[previeusIndex].ad_video!
        viewContollers[previeusIndex].isOnline = advisors[previeusIndex].isOnline!
        viewContollers[previeusIndex].liveChat = advisors[previeusIndex].liveChat!
        viewContollers[previeusIndex].threeMinuteVideo = advisors[previeusIndex].threeMinuteVideo!
        
        
        viewContollers[previeusIndex].delegate = self
        
        print("Previos Stars are are \(advisors[previeusIndex].ad_stars!)")
        
        return viewContollers[previeusIndex]
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = viewContollers.index(of: viewController as! AdvisorList) else { return nil }
        pagecount.currentPage = vcIndex
        let nextIndex = vcIndex + 1
        guard  viewContollers.count != nextIndex else {return nil}
        guard viewContollers.count > nextIndex else {return nil}
        
        if nextIndex > viewContollers.count
        {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let vc22 = sb.instantiateViewController(withIdentifier: "mmmm")
            self.view.addSubview(vc22.view)
            
        }
        viewContollers[nextIndex].abc = "\(IMAGE_BASE_URL)"+advisors[nextIndex].ad_image!
        viewContollers[nextIndex].desc = advisors[nextIndex].ad_desc!
        viewContollers[nextIndex].userName = advisors[nextIndex].ad_name!
        viewContollers[nextIndex].rating = advisors[nextIndex].ad_stars!
        viewContollers[nextIndex].advisorId = advisors[nextIndex].ad_id!
        viewContollers[nextIndex].ad_video = advisors[nextIndex].ad_video!
        viewContollers[nextIndex].delegate = self
        viewContollers[nextIndex].isOnline = advisors[nextIndex].isOnline!
        viewContollers[nextIndex].liveChat = advisors[nextIndex].liveChat!
        viewContollers[nextIndex].threeMinuteVideo = advisors[nextIndex].threeMinuteVideo!
        
        
        print("Next Stars are are \(advisors[nextIndex].ad_stars!)")
        return viewContollers[nextIndex]
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return ALL_AD.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ad", for: indexPath) as! Ad
        
        
        let img = "\(ALL_AD[indexPath.row].profileImage)"
        let add = "\(IMAGE_BASE_URL)"+"\(img)"
        let url = URL(string: add)
        Nuke.loadImage(with: url!, into:  cell.img)
        
        
        
        cell.userName.text = "\(ALL_AD[indexPath.row].legalNameOfIndividual)"
        
        cell.insight.text = "\(ALL_AD[indexPath.row].serviceName)"
        
        //        let img = "\(ALL_AD[indexPath.row].profileImage)"
        //        let add = "\(IMAGE_BASE_URL)"+"\(img)"
        //        let url = URL(string: add)
        //        cell.userImage.kf.setImage(with: url)
        //
        //        cell.userImage.clipsToBounds = true
        //        cell.userImage.layer.cornerRadius = 10
        
        
        
        if "\(ALL_AD[indexPath.row].isOnline)" == "0"
        {
            cell.onlineView.backgroundColor = .gray
        }
        else
        {
            cell.onlineView.backgroundColor = .green
        }
        
        
        if "\(ALL_AD[indexPath.row].liveChat)" == "0"
        {
            cell.chatImage.isHidden = true
        }
        else
        {
            cell.chatImage.isHidden = false
        }
        
        
        
        if "\(ALL_AD[indexPath.row].threeMinuteVideo)" == "0"
        {
            cell.videoImage.isHidden = true
        }
        else
        {
            cell.videoImage.isHidden = false
        }
        
        
        
        let stars = "\(ALL_AD[indexPath.row].rating)"
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
        
        cell.backgroundView = .none
        cell.backgroundColor = .clear
        
        return cell
        
        
        
        
        
        
        
        
        
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    {
        if indexPath.row == ALL_AD.count - 3
        {  //numberofitem count
            updateNextSet()
        }
    }
    
    func updateNextSet()
    {
        if api_type == "normal"
        {
            if currentPage < ALL_PAGES
            {
                currentPage = currentPage + 1
                fetchAdvisors(page: "\(currentPage)")
            }
        } else if api_type == "sortAPI"
        {
            if sortPageCount < sortTotalPages
            {
                self.sortPageCount = self.sortPageCount + 1
                self.sortFilter(sortValue: self.sortValue, page: "\(self.sortPageCount)")
            }
            
        }
        
        
        
    }
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        
        
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "AdivsorHeaderCollectionReusableView2", for: indexPath as IndexPath)
        headerView.viewWithTag(0)?.addSubview(pageViewController.view)
        
        
        let size = CGSize(width: (headerView.viewWithTag(0)?.frame.width)!, height: 180)
        pageViewController.view.frame.size = size
        self.pagecount.currentPageIndicatorTintColor = UIColor.white
        let customView = UIView(frame: CGRect(x: 0, y: 0, width:(headerView.viewWithTag(0)?.frame.width)!, height: 37))
        customView.backgroundColor = .clear
        headerView.viewWithTag(0)?.addSubview(customView)
        self.pagecount.center = customView.center
        
        customView.center = headerView.viewWithTag(0)!.center
        customView.frame.origin.y = 180
        customView.addSubview(pagecount)
        return headerView
        
        
        
    }
    
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        
        self.advisorID = "\(ALL_AD[indexPath.row].id)"
        self.performSegue(withIdentifier: "details", sender: nil)
        
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "details"
        {
            let vc =  segue.destination as! ShowAdvisorDetails
            vc.advisorID = self.advisorID
            vc.type = "home"
            
            
        } else if segue.identifier == "oneChatttt"
        {
            let vc  = segue.destination as! OneChat
            vc.senderId = self.advisorID
            vc.from = "home"
        }
    }
    
    
    @IBAction func sortBtn(_ sender: Any)
    {
        
        sortNib =  Bundle.main.loadNibNamed("SortNib", owner: self, options: nil)?[0] as! SortNib
        sortNib.closeBtn.addTarget(self, action: #selector(cancel(_:)), for: .touchUpInside)
        sortNib.userRating.addTarget(self, action: #selector(userRating(_:)), for: .touchUpInside)
        sortNib.highToLow.addTarget(self, action: #selector(highToLowPrice(_:)), for: .touchUpInside)
        sortNib.lowtoHight.addTarget(self, action: #selector(lowToHighPrice(_:)), for: .touchUpInside)
        sortNib.numberOfReviews.addTarget(self, action: #selector(numberofReviews(_:)), for: .touchUpInside)
        sortNib.frame = self.view.frame
        self.view.addSubview(sortNib)
    }
    
    @objc func cancel(_ sender: UIButton!)
    {
        blurredEffectView.removeFromSuperview()
        sortNib.removeFromSuperview()
        
    }
    @objc func userRating(_ sender: UIButton!)
    {
        blurredEffectView.removeFromSuperview()
        sortNib.removeFromSuperview()
        self.sortValue = "rating"
        sortFilter(sortValue:self.sortValue, page: "\(sortPageCount)")
    }
    @objc func lowToHighPrice(_ sender: UIButton!)
    {
        blurredEffectView.removeFromSuperview()
        sortNib.removeFromSuperview()
        self.sortValue = "lowToHigh"
        sortFilter(sortValue:self.sortValue, page: "\(sortPageCount)")
    }
    @objc func highToLowPrice(_ sender: UIButton!)
    {
        blurredEffectView.removeFromSuperview()
        sortNib.removeFromSuperview()
        self.sortValue = "highToLow"
        sortFilter(sortValue:self.sortValue, page: "\(sortPageCount)")
    }
    @objc func numberofReviews(_ sender: UIButton!)
    {
        blurredEffectView.removeFromSuperview()
        sortNib.removeFromSuperview()
        self.sortValue = "reviews"
        sortFilter(sortValue: self.sortValue, page: "\(sortPageCount)")
    }
    @IBAction func filterBrn(_ sender: Any)
    {
        blurredEffectView.frame = self.view.frame
        self.view.addSubview(blurredEffectView)
        filterView =  Bundle.main.loadNibNamed("FilterView", owner: self, options: nil)?[0] as! FilterView
        filterView.searchBtn.addTarget(self, action: #selector(searchBtn(_:)), for: .touchUpInside)
        filterView.closeBtn.addTarget(self, action: #selector(closeFilterView(_:)), for: .touchUpInside)
        filterView.rangeSlider.step = 1
        upperValues = 100.0
        filterView.rangeSlider.delegate = self
        filterView.frame = self.view.frame
        filterView.reviewSlider.delegate = self
        
        filterView.firstSegment.selectedSegmentIndex = 2
        
        
        self.view.addSubview(filterView)
    }
    
    @objc func closeFilterView(_ sender: UIButton!)
    {
        blurredEffectView.removeFromSuperview()
        filterView.removeFromSuperview()
    }
    
    
    
    
    @objc func searchBtn(_ sender: UIButton!)
    {
        let fisrt = filterView.firstSegment.selectedSegmentIndex
        
        if fisrt == 0
        {
            onlineValue = "Online"
        } else if fisrt == 1
        {
            onlineValue = "Offline"
        } else if fisrt == 2
        {
            onlineValue = "Both"
        }
        
        let low = Int(lowerValues)
        let high = Int(upperValues)
        filterView.rangeSlider.maxValue = 100.0
        
        filterAdvisros(lowerLimitRate:"\(low)", upperLimitRate:"\(high)", lowerLimitReview:"\(lowerReview)", online:onlineValue, upperLimitReview:"\(higherReview)")
    }
    
    
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat)
    {
        
        upperValues = Double(maxValue)
        lowerValues = Double(minValue)
        
    }
    // review slider
    func rangeSlider(_ sender: TTRangeSlider!, didChangeSelectedMinimumValue selectedMinimum: Float, andMaximumValue selectedMaximum: Float)
    {
        higherReview = Int(selectedMaximum)
        lowerReview = Int(selectedMinimum)
    }
    
    
    
    
    
    
    func filterAdvisros(lowerLimitRate:String, upperLimitRate:String, lowerLimitReview:String, online:String, upperLimitReview:String)
    {
        if Reach.isConnectedToNetwork()
        {
            
            self.filterView.removeFromSuperview()
            self.blurredEffectView.removeFromSuperview()
            
            let baseurl = URL(string:BASE_URL+"advanceSearch")!
            var parameters = Parameters()
            
            
            
            
            
            if onlineValue == "Both"
            {
                parameters = ["both":"1", "upperLimitRate":upperLimitRate, "lowerLimitRate":lowerLimitRate, "lowerLimitReview":lowerLimitReview, "upperLimitReview":upperLimitReview]
            } else if onlineValue == "Online"
            {
                parameters = ["online":"1", "offline":"0", "upperLimitRate":upperLimitRate, "lowerLimitRate":lowerLimitRate, "lowerLimitReview":lowerLimitReview, "upperLimitReview":upperLimitReview]
                
            } else if onlineValue == "Offline"
            {
                parameters = ["online":"0", "offline":"1", "upperLimitRate":upperLimitRate, "lowerLimitRate":lowerLimitRate, "lowerLimitReview":lowerLimitReview, "upperLimitReview":upperLimitReview]
            }
            
            
            if Reach.isConnectedToNetwork()
            {
                SVProgressHUD.show(withStatus: "Please wait.....")
                Alamofire.request(baseurl, method: .get, parameters: parameters, encoding: URLEncoding.default).responseJSON{ (responseData) -> Void in
                    if((responseData.result.value) != nil)
                    {
                        SVProgressHUD.dismiss()
                        
                        let a = JSON(responseData.result.value)
                        let page1Advisors  = a["All psychics"]["data"]
                        ALL_AD.removeAll()
                        for i in 0..<page1Advisors.count
                        {
                            let id = "\(page1Advisors[i]["id"])"
                            let legalNameOfIndividual = "\(page1Advisors[i]["screenName"])"
                            let serviceName = "\(page1Advisors[i]["serviceName"])"
                            let profileImage = "\(page1Advisors[i]["profileImage"])"
                            let isOnline = "\(page1Advisors[i]["isOnline"])"
                            let rating = "\(page1Advisors[i]["rating"])"
                            let liveChat = "\(page1Advisors[i]["liveChat"])"
                            let threeMinuteVideo = "\(page1Advisors[i]["threeMinuteVideo"])"
                            
                            let oneAdivsor = AdvisorModel(id: id, legalNameOfIndividual: legalNameOfIndividual, serviceName: serviceName, profileImage: profileImage, isOnline: isOnline, rating: rating, liveChat: liveChat, threeMinuteVideo: threeMinuteVideo)
                            ALL_AD.append(oneAdivsor)
                        }
                        
                        self.secondCollectionView.reloadData()
                        
                        //                        ALL_PAGES = Int("\(a["All psychics"]["last_page"])")!
                        
                        
                        print("Filter Data")
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
        else
        {
            showPopup(msg: "Could not conenct to Internet", sender: self)
        }
    }
    
    
    
    
    
    
    
    
    func fetchAdvisors(page:String)
    {
        if Reach.isConnectedToNetwork()
        {
            let id = DEFAULTS.string(forKey: "user_id")!
            SVProgressHUD.show(withStatus: "Please wait.....")
            let baseurl = URL(string:BASE_URL+"showPsychics?page="+page)!
            var parameters = Parameters()
            print("Client URL \(baseurl)")
            parameters = [:]
            
            Alamofire.request(baseurl, method: .get, parameters: parameters, encoding: URLEncoding.default).responseJSON{ (responseData) -> Void in
                if((responseData.result.value) != nil)
                {
                    SVProgressHUD.dismiss()
                    
                    let a = JSON(responseData.result.value)
                    let page1Advisors  = a["All psychics"]["data"]
                    
                    for i in 0..<page1Advisors.count
                    {
                        let id = "\(page1Advisors[i]["id"])"
                        let legalNameOfIndividual = "\(page1Advisors[i]["legalNameOfIndividual"])"
                        let serviceName = "\(page1Advisors[i]["serviceName"])"
                        let profileImage = "\(page1Advisors[i]["profileImage"])"
                        let isOnline = "\(page1Advisors[i]["isOnline"])"
                        let rating = "\(page1Advisors[i]["rating"])"
                        let liveChat = "\(page1Advisors[i]["liveChat"])"
                        let threeMinuteVideo = "\(page1Advisors[i]["threeMinuteVideo"])"
                        
                        let oneAdivsor = AdvisorModel(id: id, legalNameOfIndividual: legalNameOfIndividual, serviceName: serviceName, profileImage: profileImage, isOnline: isOnline, rating: rating, liveChat: liveChat, threeMinuteVideo: threeMinuteVideo)
                        ALL_AD.append(oneAdivsor)
                    }
                    self.secondCollectionView.reloadData()
                    self.refreshControl.endRefreshing()
                    
                    
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
    
    
    
    
    func sortFilter(sortValue:String, page:String)
    {
        if Reach.isConnectedToNetwork()
        {
            api_type = "sortAPI"
            SVProgressHUD.show(withStatus: "Please wait.....")
            let baseurl = URL(string:BASE_URL+"search?"+sortValue+"&page="+page)!
            var parameters = Parameters()
            print("Serach URL \(baseurl)")
            parameters = [:]
            
            Alamofire.request(baseurl, method: .get, parameters: parameters, encoding: URLEncoding.default).responseJSON{ (responseData) -> Void in
                if((responseData.result.value) != nil)
                {
                    SVProgressHUD.dismiss()
                    
                    if page == "1"
                    {
                        ALL_AD.removeAll()
                    }
                    let a = JSON(responseData.result.value)
                    let page1Advisors  = a["All psychics"]["data"]
                    self.sortTotalPages = Int("\(a["All psychics"]["last_page"])")!
                    for i in 0..<page1Advisors.count
                    {
                        let id = "\(page1Advisors[i]["id"])"
                        let legalNameOfIndividual = "\(page1Advisors[i]["screenName"])"
                        let serviceName = "\(page1Advisors[i]["serviceName"])"
                        let profileImage = "\(page1Advisors[i]["profileImage"])"
                        let isOnline = "\(page1Advisors[i]["isOnline"])"
                        let rating = "\(page1Advisors[i]["rating"])"
                        let liveChat = "\(page1Advisors[i]["liveChat"])"
                        let threeMinuteVideo = "\(page1Advisors[i]["threeMinuteVideo"])"
                        
                        let oneAdivsor = AdvisorModel(id: id, legalNameOfIndividual: legalNameOfIndividual, serviceName: serviceName, profileImage: profileImage, isOnline: isOnline, rating: rating, liveChat: liveChat, threeMinuteVideo: threeMinuteVideo)
                        ALL_AD.append(oneAdivsor)
                    }
                    self.secondCollectionView.reloadData()
                    
                    
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
    
    
    
    
    
    
    
    
    
    @IBAction func homeScreen(segue: UIStoryboardSegue)
    {  
    }
    
    @IBAction func cleintHomeScreen(segue: UIStoryboardSegue)
    {
        
    }
    
    
    
    
}


