//
//  AdvisorHome.swift
//  Psychic
//
//  Created by APPLE on 1/2/19.
//  Copyright © 2019 Jobesk. All rights reserved.
//

import UIKit

import Alamofire
import SwiftyJSON
import SVProgressHUD
import Nuke

class AdvisorHome: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var rightMenuContraint: NSLayoutConstraint!
    @IBOutlet weak var filterTable: UITableView!
    
    
    var results = JSON()
    var days = String()
    var selectedIDs = ""
    var shownTable = true
    var videoAddressString = String()
    var userNameString = String()
    var questionTitleHEadingString = String()
    var imageAddressString = String()
    var countLabelString = String()
    var questionDescString = String()
    var jobIdString  = String()
    var jobCompleted = String()
    var userId = String()
    
    var replyVideo = String()
    var replyComments = String()
    var menuOpen = false
    
    let firstTimePicker = UIPickerView()
    let thepickerData = ["Select Days","Past 7 Days","Past 14 Days","Past 30 Days","Past 60 Days"]
    var userImageString = String()
     @IBOutlet weak var schduleText: UITextField!
    var daysFilter = String()
    var filterAdvisors = [FilterAdvisors]()
    var order_video = String()
    
     var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        tableView.delegate = self
        tableView.dataSource  = self
        tableView.rowHeight = 310.0
        filterTable.isHidden = true
        schduleText.inputView = firstTimePicker
        firstTimePicker.dataSource = self
        firstTimePicker.delegate = self
        rightMenuContraint.constant = 0
        filterTable.delegate = self
        filterTable.dataSource = self
        filterTable.rowHeight = 50
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)
        
        
        
        
    }
    
    @objc func refresh()
    {
          getAdvisorOrders()
    }
    
    @IBAction func advOrderScreen(segue: UIStoryboardSegue)
    {
    
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAdvisorOrders()
    }
    
    @IBAction func rightMenuBtn(_ sender: Any)
    {
        menuHandlingFunction()
        
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
    

    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView == filterTable
        {
            return self.filterAdvisors.count
        }
        else
        {
            return self.results.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        if tableView == filterTable
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell") as! FilterCell
            
            cell.nameLabel.text = "\(self.filterAdvisors[indexPath.row].name)"
            
            if self.filterAdvisors[indexPath.row].status == "0"
            {
                cell.userImage.image = UIImage(named: "")
            }
            else
            {
                cell.userImage.image = UIImage(named: "checked")
            }
            
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "JobCell") as! JobCell
            
            let count = self.results.count - indexPath.row
            
            cell.countLabel.text = "\(count)"
            
            
            
            cell.userName.text = "\(results[indexPath.row]["customerName"])"
            
            let imageAddress = "\(IMAGE_BASE_URL)\(results[indexPath.row]["userImage"])"
            let url = URL(string: imageAddress)
            Nuke.loadImage(with: url!, into: cell.jobImage)
            cell.heading.text = "\(results[indexPath.row]["order_heading"])"
            cell.jobDesc.text = "\(results[indexPath.row]["order_details"])"
            let wholeDate = "\(results[indexPath.row]["created_at"])"
            
            if "\(results[indexPath.row]["order_video"])" == "0"
            {
                cell.playImage.isHidden = true
            }
            else
            {
                cell.playImage.isHidden = false
            }
            
            let utc = wholeDate
            let local = utc.fromUTCToLocalDateTime()
            let time = timeInterval(timeAgo: local)
            cell.dateLabel.text = time
            
            let isCompeleted = "\(results[indexPath.row]["isCompleted"])"
            
            if isCompeleted == "0"
            {
                cell.countBanck.backgroundColor = myBlueColor
                cell.containerView.backgroundColor = myBlueColor
            } else if isCompeleted == "1"
            {
                cell.countBanck.backgroundColor = myGreenColor
                cell.containerView.backgroundColor = myGreenColor
            } else if isCompeleted == "3"
            {
                cell.countBanck.backgroundColor = myRedColor
                cell.containerView.backgroundColor = myRedColor
            }
            cell.selectionStyle = .none
            
            return cell
        }
        
        
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        if tableView == filterTable
        {
            if self.filterAdvisors[indexPath.row].status == "0"
            {
                    self.filterAdvisors[indexPath.row].status = "1"
            }
            else
            {
                self.filterAdvisors[indexPath.row].status = "0"
            }
            filterTable.reloadData()
        }
        else
        {
            self.videoAddressString     = "\(results[indexPath.row]["order_video"])"
            self.userNameString         = "\(results[indexPath.row]["customerName"])"
            questionTitleHEadingString  = "\(results[indexPath.row]["order_heading"])"
            self.questionDescString     = "\(results[indexPath.row]["order_details"])"
            let count = self.results.count - indexPath.row - 1
            self.countLabelString       = "\(count)"
            imageAddressString          = "\(results[indexPath.row]["userImage"])"
            jobIdString                 = "\(results[indexPath.row]["id"])"
            jobCompleted                = "\(results[indexPath.row]["isCompleted"])"
            replyVideo                  = "\(results[indexPath.row]["reply_Video"])"
            replyComments               = "\(results[indexPath.row]["reply_details"])"
            userId                      = "\(results[indexPath.row]["userId"])"
            order_video                 = "\(results[indexPath.row]["order_video"])"
            self.performSegue(withIdentifier: "detailsScreen", sender: nil)
        }
        
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "detailsScreen"
            {
                let vc = segue.destination as! JobDetails
                    vc.countLabelString = self.countLabelString
                    vc.questionDescString = self.questionDescString
                    vc.questionTitleHEadingString  = self.questionTitleHEadingString
                    vc.videoAddressString = self.videoAddressString
                    vc.imageAddressString  = self.imageAddressString
                    vc.userNameString = self.userNameString
                    vc.jobIdString = self.jobIdString
                    vc.isCompleted = self.jobCompleted
                    vc.replyVideo   = self.replyVideo
                    vc.replyCommentsString = self.replyComments
                    vc.userId       = self.userId
                    vc.order_video  = self.order_video
            }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    
    func getAdvisorOrders()
    {
        if Reach.isConnectedToNetwork()
        {
            let id = DEFAULTS.string(forKey: "user_id")!
            
            SVProgressHUD.show(withStatus: "Please Wait.. ")
            let baseurl = URL(string:BASE_URL+"showAdvisorOrder?advisorId="+id)!
            var parameters = Parameters()
            
            
            parameters = [:]
            
            Alamofire.request(baseurl, method: .get, parameters: parameters, encoding: URLEncoding.default).responseJSON{ (responseData) -> Void in
                if((responseData.result.value) != nil)
                {
                    SVProgressHUD.dismiss()
                    let a = JSON(responseData.result.value)
                    let statusCode = "\(a["statusCode"])"
                    if statusCode == "1"
                    {
                        
                        self.results = a["Result"]
                        if self.results.count > 0
                        {
                            
                            let filter = a["users"]
                           
                                self.filterAdvisors.removeAll()
                                for i in 0..<filter.count
                                {
                                    let name = "\(filter[i]["customerName"])"
                                    let id = "\(filter[i]["id"])"
                                    let oneAdvisor = FilterAdvisors(name: name, status: "0", userID: id)
                                    self.filterAdvisors.append(oneAdvisor)
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
                    
                    print("THese are advisor orders")
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
    
    @IBAction func filterButtonPressed(_ sender: Any)
    {
        tablehideShow()
    }
    func tablehideShow()
    {
        if shownTable
        {
            filterTable.isHidden = false
        }
        else
        {
            filterTable.isHidden = true
        }
        
        shownTable = !shownTable
    }
    
    @IBAction func appleBtn(_ sender: Any)
    {
        selectedIDs = ""
        for i in 0..<self.filterAdvisors.count
        {
            print("Status is \(self.filterAdvisors[i].status)")
            if self.filterAdvisors[i].status == "1"
            {
                
                let oneID = self.filterAdvisors[i].userID + ","
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
    

    
    
    
    @IBAction func orderScreen(segue: UIStoryboardSegue) {
        
    }
    
    
    func filterDataByName()
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
                let baseurl = URL(string:BASE_URL+"showAdvisorOrder")!
                var parameters1 = Parameters()
                parameters1 = ["advisorId":id, "userId":selectedStringIds, "days":days]
                print("Parameters are \(parameters1)")
                Alamofire.request(baseurl, method: .get, parameters: parameters1, encoding: URLEncoding.default).responseJSON{ (responseData) -> Void in
                    if((responseData.result.value) != nil)
                    {
                        
                        SVProgressHUD.dismiss()
                        self.filterAdvisors.removeAll()
                        print("THese are advisor orders")
                        let a = JSON(responseData.result.value)
                        let statusCode = "\(a["statusCode"])"
                        
                        if statusCode == "1"
                        {
                            
                            self.results = a["Result"]
                            if self.results.count > 0
                            {
                                let filter = a["users"]
        
                                for i in 0..<filter.count
                                {
                                    let name = "\(filter[i]["customerName"])"
                                    let id = "\(filter[i]["id"])"
                                    let oneAdvisor = FilterAdvisors(name: name, status: "0", userID: id)
                                    self.filterAdvisors.append(oneAdvisor)
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
    }
    
    
    
    func filterDataByDays(days:String)
    {
            menuHandlingFunction()
            if Reach.isConnectedToNetwork()
            {
                let id = DEFAULTS.string(forKey: "user_id")!
                SVProgressHUD.show(withStatus: "Please Wait...")
                let baseurl = URL(string:BASE_URL+"showAdvisorOrder")!
                var parameters = Parameters()
                parameters = ["advisorId":id, "days":days]
                print("Parameters are \(parameters)")
                Alamofire.request(baseurl, method: .get, parameters: parameters, encoding: URLEncoding.default).responseJSON{ (responseData) -> Void in
                    if((responseData.result.value) != nil)
                    {
                        SVProgressHUD.dismiss()
                        self.filterAdvisors.removeAll()
                        print("THese are advisor orders")
                        let a = JSON(responseData.result.value)
                        let statusCode = "\(a["statusCode"])"   
                        if statusCode == "1"
                        {
                            
                            self.results = a["Result"]
                            if self.results.count > 0
                            {
                                let filter = a["users"]
                                
                                for i in 0..<filter.count
                                {
                                    let name = "\(filter[i]["customerName"])"
                                    let id = "\(filter[i]["id"])"
                                    let oneAdvisor = FilterAdvisors(name: name, status: "0", userID: id)
                                    self.filterAdvisors.append(oneAdvisor)
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
    
    
    
    
    

}
