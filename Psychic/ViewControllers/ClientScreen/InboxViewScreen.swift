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
class InboxViewScreen: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let dateFormat = "yyyy-MM-dd HH:mm:ss"
    @IBOutlet weak var tableView: UITableView!
    
    var chats = JSON()
    var profileImageString = String()
    var userNameString = String()
    var chatRate = String()
    var advisorId = String()
    var gameTimer : Timer!
    var sentTo = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        if self.revealViewController() != nil
        {
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
        
        getChat()
        
        
        
        
        
    }
    @IBAction func backBTn(_ sender: Any)
    {
        self.gameTimer.invalidate()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return chats.count
        
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "firstChatCell") as! ClientChatCell
        
        cell.userNAme.text = "\(chats[indexPath.row]["screenName"])"

        if "\(chats[indexPath.row]["chat_counter"])" == "0"
        {
            cell.counterView.isHidden = true
        }
        else
        {
            cell.counterView.isHidden = false
            cell.chatCounter.text = "\(chats[indexPath.row]["chat_counter"])"
        }
        let url = URL(string: "\(IMAGE_BASE_URL)\(chats[indexPath.row]["profileImage"])")
        self.chatRate = "\(chats[indexPath.row]["TextChatRate"])"
        Nuke.loadImage(with: url!, into: cell.profileImage)
        
        
        let utc = "\(chats[indexPath.row]["created_at"])"
        let local = utc.fromUTCToLocalDateTime()
        let time = timeInterval(timeAgo: local)
        cell.timeLabel.text = time
        
        cell.msg.text = "\(chats[indexPath.row]["message"])"
        cell.profileImage.layer.cornerRadius = 22
        cell.profileImage.clipsToBounds = true
        cell.selectionStyle = .none
        
        return cell
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        gameTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(getChat), userInfo: nil, repeats: true)
        
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.gameTimer.invalidate()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if "\(chats[indexPath.row]["sentBy"])" == DEFAULTS.string(forKey: "user_id")!
        {
                self.sentTo = "\(chats[indexPath.row]["sentTo"])"
        }
        else
        {
                self.sentTo = "\(chats[indexPath.row]["sentBy"])"
        }
        self.advisorId = "\(chats[indexPath.row]["sentBy"])"
        self.userNameString = "\(chats[indexPath.row]["screenName"])"
        self.profileImageString = "\(IMAGE_BASE_URL)\(chats[indexPath.row]["profileImage"])"
        
        performSegue(withIdentifier: "detailChat", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailChat"
        {
            let vc = segue.destination as! OneChat
                vc.senderId = advisorId
                vc.sentTo = self.sentTo
                vc.userNameString = userNameString
                vc.profileImageString = profileImageString
                vc.chatRate = self.chatRate
                vc.from = "inbox"
            
        }
    }
    
    
    @IBAction func inboxViewScreen(segue: UIStoryboardSegue)
    {
        
    }
    
    @objc func getChat()
    {
        if Reach.isConnectedToNetwork()
        {
            
            
            let id = DEFAULTS.string(forKey: "user_id")!
            let baseurl = URL(string:BASE_URL+"getConversationuser?sentBy="+id)!
            
            
            print(baseurl)
            var parameters = Parameters()
            parameters = [:]
            
            Alamofire.request(baseurl, method: .get, parameters: parameters, encoding: URLEncoding.default).responseJSON{ (responseData) -> Void in
                if((responseData.result.value) != nil)
                {
                    
                    
                    print("ChatScreen")
                    let a = JSON(responseData.result.value)
                        self.chats = a["Result"]
                    
                    self.tableView.reloadData()
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

    
    
    
    @IBAction func inboxView(segue: UIStoryboardSegue) {
        
    }
}
