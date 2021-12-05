//
//  RevenueScreens.swift
//  Psychic
//
//  Created by APPLE on 3/29/19.
//  Copyright © 2019 Jobesk. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class RevenueScreens: UIViewController, UITableViewDelegate, UITableViewDataSource, SWRevealViewControllerDelegate{
    
    
    
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pendingAmounts: UILabel!
    
    @IBOutlet weak var totalEarning: UILabel!
    var revnues = JSON()
    var st = 0
    var oneValue = JSON()
    
    let btn = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenu(sender: self, menuBtn: menuBtn)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 100
        tableView.backgroundView = .none
        tableView.backgroundColor = .clear
        getPaymentDetails()
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
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if st == 0
        {
            return 0
        } else if self.revnues.count > 3
        {
            return self.revnues.count
        }
        else
        {
            return self.revnues.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "revnueCell") as! RevnueCell
        cell.amountValue.text = "£ \(self.revnues[indexPath.row]["credit"])"
        cell.refType.text = "\(self.revnues[indexPath.row]["refrence"])"
        //        cell.dateLabel.text = "\(self.revnues[indexPath.row]["created_at"])"
        
        var fulltime: String = "\(self.revnues[indexPath.row]["created_at"])"
        let fullNameArr = fulltime.components(separatedBy: " ")
        
        let dateString = fullNameArr[0] // change to your date format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: dateString)
        
        dateFormatter.dateFormat = "dd-MM-YYYY"
        let goodDate = dateFormatter.string(from: date!)
        
        print("The Good Date is \(goodDate)")
        let dateAsString = fullNameArr[1]
        dateFormatter.dateFormat = "HH:mm:ss"
        
        let time = dateFormatter.date(from: dateAsString)
        dateFormatter.dateFormat = "h:mm a"
        let Date12 = dateFormatter.string(from: time!)
        
        
        cell.dateLabel.text = "\(Date12) \(goodDate)"
        
        
        
        
        cell.selectionStyle = .none
        cell.backgroundView = .none
        cell.backgroundColor = .clear
        return cell
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.oneValue = self.revnues[indexPath.row]
        self.performSegue(withIdentifier: "oneDetail", sender: nil)
    }
    
    
    
    func getPaymentDetails()
    {
        if Reach.isConnectedToNetwork()
        {
            
            SVProgressHUD.show(withStatus: LOADING_STRING)
            let id = DEFAULTS.string(forKey: "user_id")!
            let baseurl = URL(string:BASE_URL+"payment?advisorId="+id)!
            var parameters = Parameters()
            
            
            parameters = [:]
            
            Alamofire.request(baseurl, method: .get, parameters: parameters, encoding: URLEncoding.default).responseJSON{ (responseData) -> Void in
                if((responseData.result.value) != nil)
                {
                    SVProgressHUD.dismiss()
                    print("Revenue...")
                    let a = JSON(responseData.result.value)
                    print(a)
                    let statusCode  = "\(a["statusCode"])"
                    if statusCode == "1"
                    {
                        self.totalEarning.text = "£ \(a["withdrawabableAmount"])"
                        self.revnues = a["pendingPaymentDetails"]
                        self.pendingAmounts.text = "£ \(a["pendingPayments"])"
                        self.st = 1
                        self.tableView.reloadData()
                    }
                    
                    
                    
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
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "oneDetail"
        {
            let vc = segue.destination as! OneRevenue
            vc.oneValue = self.oneValue
        }
    }
    
    
}
