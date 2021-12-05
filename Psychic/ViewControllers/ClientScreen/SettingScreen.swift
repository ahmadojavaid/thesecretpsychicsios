//
//  SettingScreen.swift
//  Psychic
//
//  Created by APPLE on 1/21/19.
//  Copyright © 2019 Jobesk. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import SwiftyJSON

class SettingScreen: UIViewController, SWRevealViewControllerDelegate {

    @IBOutlet weak var notificaionSwitch: UISwitch!
    @IBOutlet weak var setOnlineSwitch: UISwitch!
    @IBOutlet weak var chatSwitch: UISwitch!
    @IBOutlet weak var videoChatSwitch: UISwitch!
    @IBOutlet weak var menuBtn: UIButton!
    
    var btn = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenu(sender: self, menuBtn: menuBtn)
        setOnlineSwitch.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
        
        
        
        
        videoChatSwitch.addTarget(self, action: #selector(videoSwitchAction), for: UIControl.Event.valueChanged)
        chatSwitch.addTarget(self, action: #selector(liveChatSwitch), for: UIControl.Event.valueChanged)
        
        
       
            let bb = DEFAULTS.string(forKey: "isOnline")!
            if bb == "1"
            {
                setOnlineSwitch.setOn(true, animated: false)
                DEFAULTS.set("1", forKey: "isOnline")
            }
            else
            {
                setOnlineSwitch.setOn(false, animated: false)
                DEFAULTS.set("0", forKey: "isOnline")
            }
            
        
        let videoChat = DEFAULTS.string(forKey: "videoChat")!
        
        if videoChat == "1"
        {
            videoChatSwitch.isOn = true
        }
        else
        {
            videoChatSwitch.isOn = false
        }
        
        
        let liveChat = DEFAULTS.string(forKey: "liveChat")!
        if liveChat == "1"
        {
            chatSwitch.isOn = true
        }
        else
        {
             chatSwitch.isOn = false
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
    
    @objc func switchChanged(mySwitch: UISwitch) {
        let value = mySwitch.isOn
        print("Switch VAlue is \(value)")
        if value == true
        {
            DEFAULTS.set("1", forKey: "isOnline")
            setOnlineOffStatus(status:"\(1)")
            
        }
        else
        {
            DEFAULTS.set("0", forKey: "isOnline")
            setOnlineOffStatus(status:"\(0)")
        }
        
        
    }
    
    @objc func videoSwitchAction(mySwitch: UISwitch)
    {
    
        let value = mySwitch.isOn
        
        if value == true
        {
            DEFAULTS.set("1", forKey: "videoChat")
            liveVideoChat(status:"1")
            
        }
        else
        {
            liveVideoChat(status:"0")
            DEFAULTS.set("0", forKey: "videoChat")
        }
    
    
    }
    
     @objc func liveChatSwitch(mySwitch: UISwitch)
     {
        
        let value = mySwitch.isOn
        
        if value == true
        {
            DEFAULTS.set("1", forKey: "liveChat")
            liveChatStatus(status: "1")
        }
        else
        {
            DEFAULTS.set("0", forKey: "liveChat")
            liveChatStatus(status:"0")
            
        }
    
    
    }
    
    
    
    
    
    
    @IBAction func gotoSite(_ sender: Any)
    {
        guard let url = URL(string: "http://www.thesecretpsychics.com/") else { return }
        UIApplication.shared.open(url)
    }
    
    
    
    
    func setOnlineOffStatus(status:String)
    {
        
        if Reach.isConnectedToNetwork()
        {
            let id = DEFAULTS.string(forKey: "user_id")!
            SVProgressHUD.show(withStatus: "Chnaging Status")
            let baseurl = URL(string:BASE_URL+"updateOnlineStatus/"+id+"?status="+status)!
            var parameters = Parameters()
            parameters = [:]
            Alamofire.request(baseurl, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON{ (responseData) -> Void in
                if((responseData.result.value) != nil)
                {
                    SVProgressHUD.dismiss()
                    
                    print("Set online Status......")
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
    
    
    
    func liveChatStatus(status:String)
    {
        
        if Reach.isConnectedToNetwork()
        {
            let id = DEFAULTS.string(forKey: "user_id")!
            SVProgressHUD.show(withStatus: "Chnaging Status")
            let baseurl = URL(string:BASE_URL+"updateAdvisorInfo/"+id)!
            var parameters = Parameters()
            parameters = ["liveChat":status]
            Alamofire.request(baseurl, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON{ (responseData) -> Void in
                if((responseData.result.value) != nil)
                {
                    SVProgressHUD.dismiss()
                    
                    print("Set online Status......")
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
    
    
    func liveVideoChat(status:String)
    {
        
        if Reach.isConnectedToNetwork()
        {
            let id = DEFAULTS.string(forKey: "user_id")!
            SVProgressHUD.show(withStatus: "Chnaging Status")
            let baseurl = URL(string:BASE_URL+"updateAdvisorInfo/"+id)!
            var parameters = Parameters()
            parameters = ["threeMinuteVideo":status]
            Alamofire.request(baseurl, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON{ (responseData) -> Void in
                if((responseData.result.value) != nil)
                {
                    SVProgressHUD.dismiss()
                    
                    print("Set online Status......")
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
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    @IBAction func settingScreen(segue: UIStoryboardSegue) {
        
    }
    @IBAction func ChnagePasswordRequest(_ sender: Any)
    {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let action1 = UIAlertAction(title: "Send Request", style: .default) { (action:UIAlertAction) in
            print("You've pressed default");
            
            self.userChnagePasswordRequest()
            
        }
        
        let action2 = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction) in
            print("You've pressed cancel");
            
        }
        
        
        
        alertController.addAction(action1)
        alertController.addAction(action2)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    
    
    func userChnagePasswordRequest()
    {
        if Reach.isConnectedToNetwork()
        {
            SVProgressHUD.show(withStatus: "Getting your information")
            let baseurl = URL(string:BASE_URL+"userforgotPassword")!
            let clientid = DEFAULTS.string(forKey: "user_id")!
            var parameters = Parameters()
            let email = DEFAULTS.string(forKey: "user_email")!
            parameters = ["email":email]
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
        else
        {
            showPopup(msg: "Could not conenct to Internet", sender: self)
        }
    }
    
}
