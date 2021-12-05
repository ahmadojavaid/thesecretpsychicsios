//
//  InboxViewScreen.swift
//  Psychic
//
//  Created by APPLE on 1/15/19.
//  Copyright © 2019 Jobesk. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

import Nuke

class InbView: UIViewController, UITableViewDelegate, UITableViewDataSource, SWRevealViewControllerDelegate {
    let dateFormat = "yyyy-MM-dd HH:mm:ss"
    @IBOutlet weak var tableView: UITableView!
    var senderId = ""
    
    @IBOutlet weak var menuBtn: UIButton!
    var gameTimer: Timer!
    @IBOutlet weak var backView: UIView!
    var chats = JSON()
    var profileImageString = String()
    var userNameString = String()
    
    var spinner = UIActivityIndicatorView(style: .whiteLarge)
    var advisorId = String()
    var sentBy = String()
    var sentTo = String()
    let btn = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sideMenu(sender: self, menuBtn: menuBtn)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
      
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        backView.addSubview(spinner)
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        getChat()
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
    @IBAction func backBTn(_ sender: Any)
    {
        navigationController?.popViewController(animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return chats.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "firstChatCell") as! ClientChatCell
        
        cell.userNAme.text = "\(chats[indexPath.row]["name"])"
        
        let url = URL(string: "\(IMAGE_BASE_URL)"+"\(chats[indexPath.row]["profileImage"])")
        Nuke.loadImage(with: url!, into: cell.profileImage)
        
        let utc = "\(chats[indexPath.row]["created_at"])"
        let local = utc.fromUTCToLocalDateTime()
        let time = timeInterval(timeAgo: local)
        cell.timeLabel.text = time
        
        if "\(chats[indexPath.row]["chat_counter"])" == "0"
        {
            cell.counterView.isHidden = true
        }
        else
        {
            cell.counterView.isHidden = false
            cell.chatCounter.text = "\(chats[indexPath.row]["chat_counter"])"
        }
        
        
        cell.msg.text = "\(chats[indexPath.row]["message"])"
        cell.profileImage.layer.cornerRadius = 22
        cell.profileImage.clipsToBounds = true
        
        return cell
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("I am stoped")
        self.gameTimer.invalidate()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("I am started")
        gameTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(getChat), userInfo: nil, repeats: true)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        // Chats is responose parsed
        if "\(chats[indexPath.row]["userId"])" == "\(chats[indexPath.row]["sentBy"])"
        {
            self.sentTo = "\(chats[indexPath.row]["sentTo"])"
            // sent to is value which is being sent to next Screen
        }
        else
        {
            self.sentTo = "\(chats[indexPath.row]["sentBy"])"
        }
      
        
        
        self.userNameString = "\(chats[indexPath.row]["name"])"
        self.profileImageString = "\(IMAGE_BASE_URL)"+"\(chats[indexPath.row]["profileImage"])"
        performSegue(withIdentifier: "detailChat", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailChat"
        {
            let vc = segue.destination as! ChatTwo
            
            vc.sentTo = self.sentTo
            vc.userNameString = userNameString
            vc.profileImageString = profileImageString
            vc.from = "chat"
        }
    }
    
    
    
    @objc func getChat()
    {
        if Reach.isConnectedToNetwork()
        {
            
            let id = DEFAULTS.string(forKey: "user_id")!
            let baseurl = URL(string:BASE_URL+"getConversationAdvisor?sentTo="+id)!
            
            print("Advisor Chat URL is ")
            print(baseurl)
            var parameters = Parameters()
            parameters = [:]
            
            Alamofire.request(baseurl, method: .get, parameters: parameters, encoding: URLEncoding.default).responseJSON{ (responseData) -> Void in
                if((responseData.result.value) != nil)
                {
                    
                    let a = JSON(responseData.result.value)
                    self.chats = a["Result"]
                    self.tableView.reloadData()
                    self.spinner.stopAnimating()
                    
                    print(a)
                    
                    
                }
                else
                {
                    
                    print("There was Error")
                    print("Error is \(String(describing: responseData.result.error))")
                    showPopup(msg: "Please try later", sender: self)
                }
            }// Alamofire ends here
            
        }
        else
        {
            showPopup(msg: "Could not conenct to Internet", sender: self)
        }
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    func timeInterval(timeAgo:String) -> String
    {
        let df = DateFormatter()
        
        df.dateFormat = dateFormat
        let dateWithTime = df.date(from: timeAgo)
        
        let interval = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: dateWithTime!, to: Date())
        
        if let year = interval.year, year > 0 {
            return year == 1 ? "\(year)" + " " + "year ago" : "\(year)" + " " + "years ago"
        } else if let month = interval.month, month > 0 {
            return month == 1 ? "\(month)" + " " + "month ago" : "\(month)" + " " + "months ago"
        } else if let day = interval.day, day > 0 {
            return day == 1 ? "\(day)" + " " + "day ago" : "\(day)" + " " + "days ago"
        }else if let hour = interval.hour, hour > 0 {
            return hour == 1 ? "\(hour)" + " " + "hour ago" : "\(hour)" + " " + "hours ago"
        }else if let minute = interval.minute, minute > 0 {
            return minute == 1 ? "\(minute)" + " " + "minute ago" : "\(minute)" + " " + "minutes ago"
        }else if let second = interval.second, second > 0 {
            return second == 1 ? "\(second)" + " " + "second ago" : "\(second)" + " " + "seconds ago"
        } else {
            return "a moment ago"
            
        }
    }
    
    
    
    
    @IBAction func backBtn(_ sender: Any)
    {
        self.gameTimer.invalidate()
        self.performSegue(withIdentifier: "advHome", sender: nil)
    }
    @IBAction func inboxView2222(segue: UIStoryboardSegue) {
        
    }
}

