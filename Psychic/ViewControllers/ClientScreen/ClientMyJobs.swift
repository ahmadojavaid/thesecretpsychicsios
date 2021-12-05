//
//  ClientMyJobs.swift
//  Psychic
//
//  Created by APPLE on 1/11/19.
//  Copyright © 2019 Jobesk. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

import Nuke
import AVFoundation
import MediaPlayer
import AudioToolbox
import AVKit

class ClientMyJobs: UIViewController, UITableViewDelegate, UITableViewDataSource, sessionTablecellDelegate, AVPlayerViewControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, SWRevealViewControllerDelegate {
 
    
    @IBOutlet weak var menuBtn: UIButton!
    
    @IBOutlet weak var rightMenuContraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var schduleText: UITextField!
    var btn = UIButton()
    var refreshControl = UIRefreshControl()
    var adv = [FilterAdvisors]()
    var TextChatRate = String()
    var isReviewed = String()
    var results = JSON()
    var jobs = JSON()
    var advisros = JSON()
    var selectedOrderId = String()
    let thepickerData = ["Select Days","Past 7 Days","Past 14 Days","Past 30 Days","Past 60 Days"]
    
    var selectedIDs = ""
    var days = ""
    var daysFilter = String()
    var nextName = String()
    
    let firstTimePicker = UIPickerView()

    
    var aaa = JSON()
    var tableShown = false
    // order Variables
    var isSeen  = String()
    var advisorNameString = String()
    var appIcon = String()
    var questions = String()
    var questionsDesc = String()
    var orderVideo = String()
    var advisorID = String()
    
    var menuOpen = false
    
    
    // reply variables
    
    var replyVideo = String()
    var replyCommects = String()
    var isCompeleted = String()
    
    var counting = String()
    
    
    @IBOutlet weak var filterTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenu(sender: self, menuBtn: menuBtn)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        filterTable.isHidden = true
        filterTable.delegate = self
        filterTable.dataSource = self
        filterTable.rowHeight = 50
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)
        
        
        fetchMyJobs()
        rightMenuContraint.constant = 0
        
        schduleText.inputView = firstTimePicker
        firstTimePicker.dataSource = self
        firstTimePicker.delegate = self
        
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
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView == filterTable
        {
            return self.adv.count
        }
        else
        {
            return self.jobs.count
        }
        
    }
    
    @objc func refresh()
    {
        fetchMyJobs()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        if tableView == filterTable
        {
           let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell") as! FilterCell
            cell.nameLabel.text = "\(self.adv[indexPath.row].name)"
            
            if self.adv[indexPath.row].status == "0"
            {
                cell.userImage.image = UIImage(named: "")
            }
            else
            {
                cell.userImage.image = UIImage(named: "checked")
            }
            
            cell.selectionStyle = .none
            cell.backgroundView = .none
            cell.backgroundColor = .clear
            return cell
            
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "jobCell") as! ClientJobsCell
            
            
            let aa = "\(self.jobs[indexPath.row]["advisorImage"])"
            
            let url = URL(string: "\(IMAGE_BASE_URL)"+aa)
            Nuke.loadImage(with: url!, into: cell.appIcon)
            
            
            
            let utc = "\(self.jobs[indexPath.row]["updated_at"])"
            let local = utc.fromUTCToLocalDateTime()
            let time = timeInterval(timeAgo: local)
            cell.dateLabl.text  = time
            
            
            let task = ImagePipeline.shared.loadImage(
                with: url!,
                progress: { _, completed, total in
                    //                cell.appIcon.image = cell.appIcon.image?.imageWithColor(color1: UIColor.white)
            },
                completion: { response, error in
                    //                cell.appIcon.image = cell.appIcon.image?.imageWithColor(color1: UIColor.white)
            }
            )
            
            
            cell.appIcon.clipsToBounds = true
            cell.appIcon.layer.cornerRadius = 23
            
            
            cell.catName.text = "\(self.jobs[indexPath.row]["screenName"])"
            
            //        cell.userName.text = "\(self.jobs[indexPath.row]["name"])"
            
            cell.heading.text = "\(self.jobs[indexPath.row]["order_heading"])"
            cell.details.text = "\(self.jobs[indexPath.row]["order_details"])"
            
//            if "\(self.jobs[indexPath.row]["order_video"])" == "0"
//            {
//                cell.playVideoBtnView.isHidden = true
//            }
//            else
//            {
//                cell.playVideoBtnView.isHidden = false
//            }
            
            let cc = self.jobs.count - indexPath.row
            
            cell.counltLabel.text = "\(cc)"
            let readStatus = "\(self.jobs[indexPath.row]["isSeen"])"
            if readStatus == "0"
            {
                cell.tickImage.image = UIImage(named: "singleTick")
            }
            else
            {
                
                cell.tickImage.image = UIImage(named: "doubleTick")
                cell.mainView.backgroundColor = .green
                cell.countLabelBack.backgroundColor = .green
            }
            
            self.isCompeleted  = "\(self.jobs[indexPath.row]["isCompleted"])"
            if self.isCompeleted == "1"
            {
                cell.countLabelBack.backgroundColor = myGrayColor
                cell.mainView.backgroundColor = myGreenColor
                cell.countLabelBack.backgroundColor = myGreenColor
            }
            else if self.isCompeleted == "3"
            {
                cell.mainView.backgroundColor = myRedColor
                cell.countLabelBack.backgroundColor = .red
            } else if self.isCompeleted == "0"
            {
                cell.mainView.backgroundColor = myBlueColor
                cell.countLabelBack.backgroundColor = myBlueColor
            }
            
            
            cell.selectionStyle = .none
            cell.delegate = self
            cell.indexPath = indexPath
            return cell
            
        }
        
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        if tableView == filterTable
        {
            if self.adv[indexPath.row].status == "0"
            {
                    self.adv[indexPath.row].status = "1"
            }
            else
            {
                self.adv[indexPath.row].status = "0"
            }
            
            self.filterTable.reloadData()
        }
        else
        {
            self.aaa  = self.jobs[indexPath.row]
            self.counting = "\(self.jobs.count - indexPath.row)"
            self.performSegue(withIdentifier: "orderDetails", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "orderDetails"
        {
            let vc = segue.destination as! OrderDetails
                vc.oneOrder = self.aaa
                vc.counting = self.counting
        }
    }
    
    
    
    
    
    
    
    func fetchMyJobs()
    {
        if Reach.isConnectedToNetwork()
        {
            let id = DEFAULTS.string(forKey: "user_id")!
            SVProgressHUD.show(withStatus: "Please wait.....")
            let baseurl = URL(string:BASE_URL+"showUserOrder?userId="+id)!
            var parameters = Parameters()
            
            
            parameters = [:]
            
            Alamofire.request(baseurl, method: .get, parameters: parameters, encoding: URLEncoding.default).responseJSON{ (responseData) -> Void in
                if((responseData.result.value) != nil)
                {
                    SVProgressHUD.dismiss()
                    
                    let a = JSON(responseData.result.value)
                    
                        self.adv.removeAll()
                        self.jobs = a["Result"]
                        self.advisros =  a["advisors"]
                    
                    
                        for i in 0..<self.advisros.count
                        {
                                let n = "\(self.advisros[i]["screenName"])"
                                let id = "\(self.advisros[i]["id"])"
                                let oneAdv = FilterAdvisors(name: n, status: "0", userID: id)
                                self.adv.append(oneAdv)
                        }
                    
                    
                    
                    
                    if self.jobs.count == 0
                    {
                        showPopup(msg: "You have not posted any order yet", sender: self)
                    }
                    else
                    {
                        self.tableView.isHidden = false
                        self.filterTable.reloadData()
                        self.tableView.reloadData()
                        self.refreshControl.endRefreshing()
                    }    
                    print("All ordersssss")
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
    
    @IBAction func filterBtn(_ sender: Any)
    {
        if tableShown
        {
            filterTable.isHidden = false
        }
        else
        {
            filterTable.isHidden = true
        }
        tableShown = !tableShown
    }
    
    
   
    
    
  
    
    
    
    func closeFriendsTapped(at index: IndexPath)
    {
        
        let videoAddress = "\(self.jobs[index.row]["order_video"])"
        let videoURL = URL(string: "\(BASE_URL)"+videoAddress)
        let player = AVPlayer(url: videoURL!)
        let playervc = AVPlayerViewController()
        playervc.delegate = self
        playervc.player = player
        self.present(playervc, animated: true) {
            playervc.player!.play()
        }
       
        
    }
    
    @IBAction func rightMenuBtn(_ sender: Any)
    {
        if menuOpen
        {
            rightMenuContraint.constant = 240
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
        else
        {
            rightMenuContraint.constant = 0
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
        
        menuOpen = !menuOpen
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return thepickerData.count
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        
        return thepickerData[row]
        
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        schduleText.text = thepickerData[row]
    }
    
    
    
    
    @IBAction func appleBtn(_ sender: Any)
    {
        selectedIDs = ""
        for i in 0..<self.adv.count
        {
            print("Status is \(self.adv[i].status)")
            if self.adv[i].status == "1"
            {
                
                let oneID = self.adv[i].userID + ","
                print("Ont Id \(oneID)")
                selectedIDs = selectedIDs + oneID
            }
        }
        self.daysFilter = self.schduleText.text!
        
        if selectedIDs == ""
        {
            let day = self.schduleText.text!

            if day == "Select Days"
            {
                days = ""
            } else if day == "Past 7 Days"
            {
                days = "7"
            } else  if day == "Past 14 Days"
            {
                days = "14"
            } else  if day == "Past 30 Days"
            {
                days = "30"
            } else
            {
                days = "60"
            }
            self.filterDataByDays(days: days)

        }
        else
        {
            filterDataByName()
        }
        
        
        
        
        
    }
    
    
    func menuHandlingFunction()
    {
        if menuOpen
        {
            rightMenuContraint.constant = 240
            self.filterTable.isHidden = true
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
        else
        {
            rightMenuContraint.constant = 0
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
        
        menuOpen = !menuOpen
        
        
        
        
    }
    
    
    
    
    @IBAction func orderScreen(segue: UIStoryboardSegue) {
        
    }
    
    
    func filterDataByName()
    {
        
        
        
        let day = self.schduleText.text!
        
        if day.isEmpty
        {
            days = "0"
        }
        else if day == "Select Days"
        {
            days = "0"
        } else if day == "Past 7 Days"
        {
            days = "7"
        } else  if day == "Past 14 Days"
        {
            days = "14"
        } else  if day == "Past 30 Days"
        {
            days = "30"
        } else
        {
            days = "60"
        }

        if selectedIDs.isEmpty
        {
            
        }
        else
        {
            
            let selectedStringIds = "\(selectedIDs.dropLast())"
            menuHandlingFunction()
            
            if Reach.isConnectedToNetwork()
            {
                let id = DEFAULTS.string(forKey: "user_id")!
                
                SVProgressHUD.show(withStatus: "Please Wait..")
                let baseurl = URL(string:BASE_URL+"showUserOrder")!
                var parameters1 = Parameters()
                parameters1 = ["advisorId":selectedStringIds, "userId":id, "days":days]
                print("Parameters are \(parameters1)")
                Alamofire.request(baseurl, method: .get, parameters: parameters1, encoding: URLEncoding.default).responseJSON{ (responseData) -> Void in
                    if((responseData.result.value) != nil)
                    {
                        
                        SVProgressHUD.dismiss()
                        self.adv.removeAll()
                        print("Search By Name")
                        let a = JSON(responseData.result.value)
                        let statusCode = "\(a["statusCode"])"
                        
                        if statusCode == "1"
                        {
                            
                            self.jobs = a["Result"]
                            self.adv.removeAll()
                            if self.jobs.count > 0
                            {
                                let filter = a["advisors"]
                                
                                for i in 0..<filter.count
                                {
                                    let name = "\(filter[i]["screenName"])"
                                    let id = "\(filter[i]["id"])"
                                    let oneAdvisor = FilterAdvisors(name: name, status: "0", userID: id)
                                    self.adv.append(oneAdvisor)
                                }
                                self.filterTable.reloadData()
                                self.tableView.reloadData()
                            }
                            else
                            {
                                self.tableView.isHidden = true
                            }
                            
                            print(a)
                            
                            
                            
                        }
                        else
                        {
                            showPopup(msg: "Your Orders could not found", sender: self)
                        }
                        
                        
                        
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
    
    
    
    func filterDataByDays(days:String)
    {
        menuHandlingFunction()
        if Reach.isConnectedToNetwork()
        {
            let id = DEFAULTS.string(forKey: "user_id")!
            SVProgressHUD.show(withStatus: "Please Wait...")
            let baseurl = URL(string:BASE_URL+"showUserOrder")!
            var parameters = Parameters()
            parameters = ["userId":id, "days":days]
            print("Parameters are \(parameters)")
            Alamofire.request(baseurl, method: .get, parameters: parameters, encoding: URLEncoding.default).responseJSON{ (responseData) -> Void in
                if((responseData.result.value) != nil)
                {
                    SVProgressHUD.dismiss()
                    self.adv.removeAll()
                    print("THese are advisor orders")
                    let a = JSON(responseData.result.value)
                    let statusCode = "\(a["statusCode"])"
                    if statusCode == "1"
                    {
                        self.results = a["Result"]
                        self.jobs = a["Result"]
                        if self.results.count > 0
                        {
                            let filter = a["advisors"]
                            for i in 0..<filter.count
                            {
                                let name = "\(filter[i]["screenName"])"
                                let id = "\(filter[i]["id"])"
                                let oneAdvisor = FilterAdvisors(name: name, status: "0", userID: id)
                                self.adv.append(oneAdvisor)
                            }
                            self.filterTable.reloadData()
                            self.tableView.reloadData()
                        }
                        else
                        {
                            self.tableView.isHidden = true
                        }
                    }
                    else
                    {
                        showPopup(msg: "Your Orders could not found", sender: self)
                    }
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
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    @IBAction func clientOrderScreen(segue: UIStoryboardSegue) {
        
    }
    
}


extension UIImage {
    func imageWithColor(color1: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        color1.setFill()
        
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: self.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.setBlendMode(CGBlendMode.normal)
        
        let rect = CGRect(origin: .zero, size: CGSize(width: self.size.width, height: self.size.height))
        context?.clip(to: rect, mask: self.cgImage!)
        context?.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
