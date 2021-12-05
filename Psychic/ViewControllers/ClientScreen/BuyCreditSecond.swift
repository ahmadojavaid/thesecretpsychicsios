//
//  BuyCreditSecond.swift
//  Psychic
//
//  Created by APPLE on 4/4/19.
//  Copyright © 2019 Jobesk. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD



class BuyCreditSecond: UIViewController {
    
    
    
    
    var token = String()
    
    var promoValue = "0"
    
    @IBOutlet weak var firstBtn: UIButton!
    @IBOutlet weak var secondBtn: UIButton!
    
    @IBOutlet weak var thirdBtn: UIButton!
    @IBOutlet weak var fourthBtn: UIButton!
    @IBOutlet weak var fifthBtn: UIButton!
    
    
    @IBOutlet weak var promoLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        //    sideMenu(sender: self, menuBtn: menuBtn)
        
        
        
        
        
        let alert = UIAlertController(title: "", message: "Please wait a while....", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        
        // change to desired number of seconds (in this case 5 seconds)
        let when = DispatchTime.now() + 5
        DispatchQueue.main.asyncAfter(deadline: when){
            // your code with delay
            alert.dismiss(animated: true, completion: nil)
        }
           NotificationCenter.default.addObserver(self, selector:#selector(self.refreshTableView), name: NSNotification.Name(rawValue: "updatePaymentSecond"), object: nil)
        
        
        IAP_Service.shared.getProducts()
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
      
        
        
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func refreshTableView ()
    {
        
        if BOUGHT_PRODUCT == "1"
        {
            updateCredit(price:"4.99")
        } else if BOUGHT_PRODUCT == "2"
        {
            updateCredit(price:"9.99")
        } else if BOUGHT_PRODUCT == "3"
        {
            updateCredit(price:"14.99")
        } else if BOUGHT_PRODUCT == "4"
        {
            updateCredit(price:"54.99")
        } else if BOUGHT_PRODUCT == "5"
        {
            updateCredit(price:"109.99")
            
        }
    }
    
    
    
    
    
    @IBAction func fiveDollerBtn(_ sender: Any)
    {
         disableAll()
        BUY_SCREEN = "SECOND"
        if Reach.isConnectedToNetwork()
        {
            IAP_Service.shared.purchase(id: FIRST_PRODUCT)
        }
        else
        {
            showPopup(msg: "Internet is not connected", sender: self)
        }
        
    }
    
    @IBAction func tenPoundsBtn(_ sender: Any)
    {
         disableAll()
        BUY_SCREEN = "SECOND"
        if Reach.isConnectedToNetwork()
        {
            IAP_Service.shared.purchase(id: SECOND_PRODUCT)
        }
        else
        {
            showPopup(msg: "Internet is not connected", sender: self)
        }
        
    }
    
    @IBAction func fiveteenBtn(_ sender: Any)
    {
         disableAll()
        BUY_SCREEN = "SECOND"
        if Reach.isConnectedToNetwork()
        {
            IAP_Service.shared.purchase(id: THIRD_PRODUCT)
        }
        else
        {
            showPopup(msg: "Internet is not connected", sender: self)
        }
        
        
        
    }
    @IBAction func fiftyPoundsBtn(_ sender: Any)
    {
         disableAll()
        BUY_SCREEN = "SECOND"
        if Reach.isConnectedToNetwork()
        {
            IAP_Service.shared.purchase(id: FOURTH_PRODUCT)
        }
        else
        {
            showPopup(msg: "Internet is not connected", sender: self)
        }
    }
    
    @IBAction func hundredPoundsBTn(_ sender: Any)
    {
         disableAll()
        BUY_SCREEN = "SECOND"
        if Reach.isConnectedToNetwork()
        {
            IAP_Service.shared.purchase(id: FIVTH_PRODUCT)
        }
        else
        {
            showPopup(msg: "Internet is not connected", sender: self)
        }
    }
    
    
    
    
    
    
    
    
    
    func updateCredit(price:String)
    {
        print("Second Update price called")
        if ONCE_DONE == "1"
        {
            if Reach.isConnectedToNetwork()
            {
                var p = Double()
                if promoValue == "0"
                {
                    p = Double(price)!
                }
                else
                {
                    p = Double(price)! + Double(promoValue)!
                }
                
                
                let id = DEFAULTS.string(forKey: "user_id")!
                let baseurl = URL(string:BASE_URL+"credit?userId="+id+"&credit="+"\(p)")!
                SVProgressHUD.show(withStatus: LOADING_STRING)
                var parameters = Parameters()
                parameters = [:]
                
                ONCE_DONE = "0"
                print("Update price url \(baseurl)")
                
                
                
                Alamofire.request(baseurl, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON{ (responseData) -> Void in
                    if((responseData.result.value) != nil)
                    {
                        SVProgressHUD.dismiss()
                        
                        ONCE_DONE = "0"
                        let a = JSON(responseData.result.value)
                        
                        let statusCode = "\(a["statusCode"])"
                        self.enableAll()
                        if statusCode == "1"
                        {
                            
                        }
                        else
                        {
                            
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
                showPopup(msg: "Internet could not connect", sender: self)
            }
        }
        else
        {
            
            print("I am done......")
        }
        
        
        
        
        
        
        
    }
    
    
    @IBAction func promoCode(_ sender: UITextField)
    {
        
        let str = sender.text!.count
        
        if str == 9
        {
            verifyPromoCode(code: sender.text!)
            
        } else if str > 9
        {
            sender.text =  "\(sender.text!.dropLast())"
        }
        else if str < 9
        {
            
            promoLabel.isHidden = true
        }
    }
    
    
    
    func verifyPromoCode(code:String)
    {
        if Reach.isConnectedToNetwork()
        {
            let baseurl = URL(string:BASE_URL+"verifyPromo?promo_code="+code)!
            SVProgressHUD.show(withStatus: LOADING_STRING)
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
                        self.promoLabel.textColor = myGreenColor
                        let amount = "\(a["Result"]["discount"])"
                        self.setAllGray()
                        
                        let total = "\(a["Result"]["assignedToPackage"])"
                        self.promoValue = amount
                        
                        if total == "100"
                        {
                            self.fifthBtn.isUserInteractionEnabled = true
                            self.fifthBtn.backgroundColor = myBlackColor
                        } else if total == "50"
                        {
                            self.fourthBtn.isUserInteractionEnabled = true
                            self.fourthBtn.backgroundColor = myBlackColor
                        } else if total == "15"
                        {
                            self.thirdBtn.isUserInteractionEnabled = true
                            self.thirdBtn.backgroundColor = myBlueColor
                        } else if total == "10"
                        {
                            self.secondBtn.isUserInteractionEnabled = true
                            self.secondBtn.backgroundColor = myBlueColor
                        } else if total == "5"
                        {
                            self.firstBtn.isUserInteractionEnabled = true
                            self.firstBtn.backgroundColor = myBlueColor
                        }
                        
                        self.promoLabel.text = "Congratulations, you will receive £\(amount) as Credit"
                        self.promoLabel.isHidden = false
                    }
                    else
                    {
                        self.promoLabel.textColor = myRedColor
                        self.promoLabel.text = "Invalid Promo Code"
                        self.promoLabel.isHidden = false
                    }
                    
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
            showPopup(msg: "Internet could not connect", sender: self)
        }
    }
    
    
    
    
    
    
    func setAllGray()
    {
        firstBtn.isUserInteractionEnabled = false
        secondBtn.isUserInteractionEnabled = false
        thirdBtn.isUserInteractionEnabled = false
        fourthBtn.isUserInteractionEnabled = false
        fifthBtn.isUserInteractionEnabled = false
        
        firstBtn.backgroundColor = .gray
        secondBtn.backgroundColor = .gray
        thirdBtn.backgroundColor = .gray
        fourthBtn.backgroundColor = .gray
        fifthBtn.backgroundColor = .gray
        
        
        
    }
    
    func disableAll()
    {
        firstBtn.isUserInteractionEnabled = false
        secondBtn.isUserInteractionEnabled = false
        thirdBtn.isUserInteractionEnabled = false
        fourthBtn.isUserInteractionEnabled = false
        fifthBtn.isUserInteractionEnabled = false
        
    }
    func enableAll()
    {
        firstBtn.isUserInteractionEnabled = true
        secondBtn.isUserInteractionEnabled = true
        thirdBtn.isUserInteractionEnabled = true
        fourthBtn.isUserInteractionEnabled = true
        fifthBtn.isUserInteractionEnabled = true
        
    }
    
}
