//
//  OneChat.swift
//  Psychic
//
//  Created by APPLE on 1/16/19.
//  Copyright © 2019 Jobesk. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toast_Swift
import IQKeyboardManager
import Nuke
import GrowingTextView
class OneChat: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UITextViewDelegate {
    
    
    @IBOutlet weak var innerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileImage: UIImageView!
    let myId = DEFAULTS.string(forKey: "user_id")!
    
    @IBOutlet weak var newMsg: GrowingTextView!
    var sentTo = String()
    var innerViewOpened = true
    @IBOutlet weak var containerView: UIView!
    let storyboards = UIStoryboard(name: "ClientScreens", bundle: nil)
    
    var vc1 = BuyCreditSecond()
    @IBOutlet weak var tableBottom: NSLayoutConstraint!
    var userNameString = String()
    var profileImageString = String()
    
    var chatRate = String()
    var senderId = String()
    var gameTimer: Timer!
    @IBOutlet weak var bottomConstraint12: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    var from = String()
    
    
    var myChats = [ChatMsgs]()
    
    var detailedChat = JSON()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        print("Adivsor Id \(senderId)")
        
        self.innerViewHeight.constant = self.view.frame.height
        innerViewOpened = false
        vc1 = storyboards.instantiateViewController(withIdentifier: "BuyCreditSecond") as! BuyCreditSecond
        
        vc1.view.frame = self.containerView.frame
        containerView.addSubview(vc1.view)
        
        
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        tableView.delegate = self
        tableView.dataSource = self
        let url = URL(string: "\(profileImageString)")
        Nuke.loadImage(with: url!, into: profileImage)
        
        print("Prfole URL is \(url!)")
        
        userName.text = userNameString
        profileImage.layer.cornerRadius = 15
        profileImage.clipsToBounds = true
        getChatDetailed()
        
        
        
        gameTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(getChatDetailed), userInfo: nil, repeats: true)
        
        
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
        let sentTo1 = "\(detailedChat[indexPath.row]["sentTo"])"
        cell.msg.text = "\(detailedChat[indexPath.row]["message"])"
        
        
        
        let utc = "\(detailedChat[indexPath.row]["created_at"])"
        let local = utc.fromUTCToLocalDateTime()
        let time = timeInterval(timeAgo: local)
        let uerId = "\(detailedChat[indexPath.row]["created_at"])"
        cell.timeLabel.text = time
        
        
        if sentTo1 == myId
        {
            cell.timeLabel.textColor = myBlueColor
            cell.backView.backgroundColor = .white
            cell.msg.textColor = myBlueColor
            cell.leftConstraint.constant = 10
            cell.rightConstraint.constant = 100
        }
        else
        {
            cell.backView.backgroundColor = myBlueColor
            cell.msg.textColor = .white
            cell.leftConstraint.constant = 100
            cell.rightConstraint.constant = 10
            cell.timeLabel.textColor = .white
        }
        
        
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        
        return cell
    }
    
    
    func textViewDidChange(_ textView: UITextView) { //Handle the text changes here
        
        
        let str = newMsg.text!.count
        if str > 0
        {
            counterLabel.text = "Char \(str)"
            var ans: Float?
            ans = Float(str) / 160
            let b = Int((ans?.rounded(.up))!)
            let price = Float(self.chatRate)! * Float(b)
            self.rateLabel.text = "\(price) £"
            counterLabel.isHidden = false
            rateLabel.isHidden = false
        }
        else
        {
            counterLabel.isHidden = true
            rateLabel.isHidden = true
        }
        
        
    }
    
    
    
    @objc func getChatDetailed()
    {
        if Reach.isConnectedToNetwork()
        {
            
            
            let baseurl = URL(string:BASE_URL+"detailedChat?sentTo="+sentTo+"&sentBy="+myId+"&type=2")!
            print(baseurl)
            var parameters = Parameters()
            parameters = [:]
            Alamofire.request(baseurl, method: .get, parameters: parameters, encoding: URLEncoding.default).responseJSON{ (responseData) -> Void in
                if((responseData.result.value) != nil)
                {
                    
                    print("Detailed Chat")
                    let oldCount = self.detailedChat.count
                    let a = JSON(responseData.result.value)
                    print(a)
                    self.detailedChat = a["Result"]
                    if self.detailedChat.count > 0
                    {
                        self.tableView.reloadData()
                        
                        
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
            
            let character = msg.count
            var ans: Float?
            
            
            ans = Float(character) / 160
            
            let b = Int((ans?.rounded(.up))!)
            
            sendChatMsg(msg: msg, count: "\(b)")
            newMsg.resignFirstResponder()
            newMsg.text = ""
        }
        
    }
    
    
    
    func sendChatMsg(msg:String, count:String)
    {
        if Reach.isConnectedToNetwork()
        {
            
            rateLabel.isHidden = true
            counterLabel.isHidden = true
            
            let baseurl = URL(string:BASE_URL+"chat")!
            var parameters = Parameters()
            parameters = ["sentBy":myId, "sentTo":sentTo, "message":msg, "deductionCount":count, "type":"2"]
            
            print(" Send Chat Paramters are from Client Side ")
            print(parameters)
            
            
            Alamofire.request(baseurl, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON{ (responseData) -> Void in
                if((responseData.result.value) != nil)
                {
                    let a = JSON(responseData.result.value)
                    let bb = "\(a["statusCode"])"
                    if bb == "1"
                    {
                        
                        self.view.makeToast("Message sent")
                    }
                    else if bb == "403"
                    {
                        let msg = "\(a["statusMessage"])"
                        self.view.makeToast(msg)
                        self.closeInnerView()
                    }
                    else
                    {
                        let msg = "\(a["statusMessage"])"
                        self.view.makeToast(msg)
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
        if str > 0
        {
            counterLabel.text = "Char \(str)"
            var ans: Float?
            ans = Float(str) / 160
            let b = Int((ans?.rounded(.up))!)
            let price = Float(self.chatRate)! * Float(b)
            self.rateLabel.text = "\(price) £"
            counterLabel.isHidden = false
            rateLabel.isHidden = false
        }
        else
        {
            counterLabel.isHidden = true
            rateLabel.isHidden = true
        }
    }
    
    @IBAction func closeBtn(_ sender: Any)
    {
        closeInnerView()
        
    }
    
    
    func closeInnerView()
    {
        if self.innerViewOpened
        {
            self.innerViewHeight.constant = self.view.frame.height
        }
        else
        {
            self.innerViewHeight.constant = 8
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        
        
        
        innerViewOpened = !innerViewOpened
    }
    
    
    
    
    
    
    
    
    
    
    
}
