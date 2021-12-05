//
//  ChatTwo.swift
//  Psychic
//
//  Created by APPLE on 3/27/19.
//  Copyright © 2019 Jobesk. All rights reserved.
//


import UIKit
import Alamofire
import SwiftyJSON
import Nuke
import Toast_Swift
import GrowingTextView
class ChatTwo: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var sentTo = String()
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var newMsg: GrowingTextView!
    
    
    var userNameString = String()
    var profileImageString = String()
    
    
    var senderId = String()
    var gameTimer: Timer!
    
    var from = String()
    
    let myId = DEFAULTS.string(forKey: "user_id")!
    
    var myChats = [ChatMsgs]()
    
    var detailedChat = JSON()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        tableView.delegate = self
        tableView.dataSource = self
        let url = URL(string: profileImageString)
        Nuke.loadImage(with: url!, into: profileImage)
        userName.text = userNameString
        profileImage.layer.cornerRadius = 15
        profileImage.clipsToBounds = true
        getChatDetailed()
        
        
        
        gameTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(getChatDetailed), userInfo: nil, repeats: true)
        
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailedChat.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailChatCell") as! DetailChatCell
        let sentTo = "\(detailedChat[indexPath.row]["sentTo"])"
        cell.msg.text = "\(detailedChat[indexPath.row]["message"])"
        
        
        
        let utc = "\(detailedChat[indexPath.row]["created_at"])"
        let local = utc.fromUTCToLocalDateTime()
        let time = timeInterval(timeAgo: local)
        cell.timeLabel.text = time
     
        
        
        
        if sentTo == myId
        {
            cell.backView.backgroundColor = .white
            cell.msg.textColor = myBlueColor
            cell.timeLabel.textColor = myBlueColor
            cell.leftConstraint.constant = 10
            cell.rightConstraint.constant = 100
            
            
        }
        else
        {
            cell.backView.backgroundColor = myBlueColor
            cell.msg.textColor = .white
            cell.timeLabel.textColor = .white
            cell.leftConstraint.constant = 100
            cell.rightConstraint.constant = 10
            
            
        }
        
        
        cell.backgroundColor = .clear
        
        
        cell.selectionStyle = .none
        return cell
    }
    
    
    
    
    
    
    @objc func getChatDetailed()
    {
        if Reach.isConnectedToNetwork()
        {
            let baseurl = URL(string:BASE_URL+"detailedChat?sentTo="+sentTo+"&sentBy="+myId+"&type=1")!
            
            var parameters = Parameters()
            parameters = [:]
            Alamofire.request(baseurl, method: .get, parameters: parameters, encoding: URLEncoding.default).responseJSON{ (responseData) -> Void in
                if((responseData.result.value) != nil)
                {
                    
                    print("Detailed Chat")
                    let oldCount = self.detailedChat.count
                    
                    let a = JSON(responseData.result.value)
                    self.detailedChat = a["Result"]
                    self.tableView.reloadData()
                    print(a)
                    
                    if self.detailedChat.count > 0
                    {
                        
                        if self.detailedChat.count > oldCount
                        {
                            let lastRow: Int = self.tableView.numberOfRows(inSection: 0) - 1
                            let indexPath = IndexPath(row: lastRow, section: 0);
                            self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                        }
                        
                        
                        
                    }
                    
                    
                    
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
    
    
    
    
    
    
    
    
    
    
    @IBAction func sendMsg(_ sender: Any)
    {
        let msg = newMsg.text!
        
        if msg.isEmpty
        {
            
        }
        else
        {
            
            let ded: Float = Float(msg.count / 160)
            
            let aa = Int(ded.rounded(.up))
            
            print("Deduction count is \(aa)")
            
            
            sendChatMsg(msg: msg, count: "\(aa)")
            newMsg.text = ""
        }
        
    }
    
    
    
    func sendChatMsg(msg:String, count:String)
    {
        
        
        self.newMsg.resignFirstResponder()
        
        if Reach.isConnectedToNetwork()
        {
            
            
            let id = DEFAULTS.string(forKey: "user_id")!
            let baseurl = URL(string:BASE_URL+"chat")!
            var parameters = Parameters()
            parameters = ["sentBy":id, "sentTo":sentTo, "message":msg, "deductionCount":count, "type":"1"]
            
            print("Send Chat Msg Paramters are ")
            print(parameters)
            
            
            Alamofire.request(baseurl, method: .post, parameters: parameters, encoding: URLEncoding.default).responseString{ (responseData) -> Void in
                
                self.view.makeToast("Message sent")
                
                if((responseData.result.value) != nil)
                {
                    
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
        else
        {
            showPopup(msg: "Could not conenct to Internet", sender: self)
        }
    }
    
    
    
    @IBAction func backBtn(_ sender: Any)
    {
        gameTimer.invalidate()
        
        if from == "inbox"
        {
            performSegue(withIdentifier: "inbox", sender: nil)
        }
        else  if from == "order"
        {
            performSegue(withIdentifier: "oneOrder", sender: nil)
        }
        else if from == "chat"
        {
            performSegue(withIdentifier: "nokrani", sender: nil)
        }
        else
        {
            performSegue(withIdentifier: "home", sender: nil)
        }
        
        
    }
    
    @IBAction func msgsTextfiled(_ sender: UITextField)
    {
        let str = sender.text!.count
        
        
        
        
        
        
        
    }
    
}
