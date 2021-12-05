//
//  PaymentDetails.swift
//  Psychic
//
//  Created by APPLE on 1/1/19.
//  Copyright © 2019 Jobesk. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftyJSON
import Alamofire

class PaymentDetails: UIViewController, UITextFieldDelegate {
    
    //screen variables
    @IBOutlet weak var minuteRate: UITextField!
    @IBOutlet weak var chatRate: UITextField!
    @IBOutlet weak var legalName: UITextField!
    @IBOutlet weak var birthDay: UITextField!
    @IBOutlet weak var birthMonth: UITextField!
    @IBOutlet weak var birthYear: UITextField!
    @IBOutlet weak var country: UITextField!
    @IBOutlet weak var permanentAddress: UITextField!
    @IBOutlet weak var zipCode: UITextField!
    @IBOutlet weak var cityName: UITextField!
    @IBOutlet weak var backAccountNumber: UITextField!
    @IBOutlet weak var paymentThrash: UITextField!
    @IBOutlet weak var chatRateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title  = "Payment Details"
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func submitBtnPressed(_ sender: Any)
    {
        let minRate = minuteRate.text!
        let chRate  = chatRate.text!
        let lglName = legalName.text!
        let bDay = birthDay.text!
        let bMonth = birthMonth.text!
        let bYear = birthYear.text!
        let molak = country.text!
        let address = permanentAddress.text!
        let zip = zipCode.text!
        let city = cityName.text!
        let acc = backAccountNumber.text!
        let payment = paymentThrash.text!
        
        chatRate.delegate = self
        
        if minRate.isEmpty
        {
            showPopup(msg: "Please type minutes rate", sender: self)
        } else if chRate.isEmpty
        {
            showPopup(msg: "Please type Chat rate", sender: self)
        } else if lglName.isEmpty
        {
            showPopup(msg: "Please type legal name", sender: self)
        } else if checkName(name: lglName)
        {
            showPopup(msg: "Legal Name Must not contain special Character or numbers", sender: self)
        } else if bDay.isEmpty
        {
            showPopup(msg: "Please Type a valid day", sender: self)
        } else
        {
            let aa = Int(bDay)!
            if aa > 31
            {
                showPopup(msg: "Please type a valid Day", sender: self)
            } else if bMonth.isEmpty
            {
                showPopup(msg: "Please type a valid Month", sender: self)
            }
            else
            {
                let bb = Int(bMonth)!
                if bb > 12
                {
                    showPopup(msg: "Please type a valid Month ", sender: self)
                }
                else if bYear.isEmpty
                {
                    showPopup(msg: "Please type a valid year", sender: self)
                }
                else
                {
                    let cc = Int(bYear)!
                    if cc < 1910
                    {
                        showPopup(msg: "Please provide a valid year", sender: self)
                    }
                    else if molak.isEmpty
                    {
                        showPopup(msg: "Please type a valid country Name", sender: self)
                    }else if checkName(name: molak)
                    {
                        showPopup(msg: "Country Name Must not contain special character or numbers", sender: self)
                    } else if address.isEmpty
                    {
                        showPopup(msg: "Please type a valid address", sender: self)
                    } else if checkName(name: address)
                    {
                        showPopup(msg: "Address must not contain special characters or numbers", sender: self)
                    }else if zip.isEmpty
                    {
                        showPopup(msg: "Please type a valid zip code", sender: self)
                    } else if city.isEmpty
                    {
                        showPopup(msg: "Please type a valid city Name", sender: self)
                    } else if checkName(name: city)
                    {
                        showPopup(msg: "City must not contain special character or numbers", sender: self)
                    }
                    else if acc.isEmpty
                    {
                        showPopup(msg: "Please type a valid bank account number", sender: self)
                    } else if payment.isEmpty
                    {
                        showPopup(msg: "Please type payment thrashold", sender: self)
                    } else if checkOnlyNumbers(string: payment)
                    {
                        showPopup(msg: "invalid Payment Threshold", sender: self)
                    } else
                    {
                        let dob = bYear+"-" + bMonth+"-" + bDay
                        update(paymentThreshold: payment, bankDetails: acc, City: city, ZipCode: zip, permanentAddress: address, country: molak, DateofBirth: dob, LegalNameOfIndividual: lglName, TextChatRate: chRate, YourTimeRate: minRate)
                        
                    }
                }
            }
        }
    }
    
    
    
    
    
    
    @IBAction func chatRateChanged(_ sender: Any)
    {
        let value = chatRate.text!
        
        if value.count > 1
        {
            let aa = Double(value)
            let fourty = aa! * 40 / 100
            self.chatRateLabel.text = "You will earn: £ \(fourty)"
        }
        else
        {
            self.chatRateLabel.text = "You will earn 40% off your charges"
        }
    }
    func update(paymentThreshold:String, bankDetails:String, City:String, ZipCode:String, permanentAddress:String, country:String, DateofBirth:String,LegalNameOfIndividual:String, TextChatRate:String, YourTimeRate:String)
    {
        
        if Reach.isConnectedToNetwork()
        {
            let id = DEFAULTS.string(forKey: "user_id")!
            let baseurl = URL(string:BASE_URL+"updateAdvisorInfo/"+id)!
            SVProgressHUD.show(withStatus: LOADING_STRING)
            var parameters = Parameters()
            
            
            parameters = ["paymentThreshold":paymentThreshold, "bankDetails":bankDetails, "city":City, "zipCode":ZipCode, "permanentAddress":permanentAddress, "country":country, "dateOfBirth":DateofBirth, "legalNameOfIndividual":LegalNameOfIndividual, "TextChatRate":TextChatRate, "timeRate":YourTimeRate, "profileStatus":"1"]
            
            
            print("Here is paremeters")
            print(parameters)
            print("Parameters ends here")
            
            
            
            Alamofire.request(baseurl, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON{ (responseData) -> Void in
                if((responseData.result.value) != nil)
                {
                    SVProgressHUD.dismiss()
                    
                    
                    let a = JSON(responseData.result.value)
                    
                    let statusCode = "\(a["statusCode"])"
                    
                    if statusCode == "1"
                    {
                        self.showPopupSecond(msg: "Your profile has been sent for aproval, please check back after 24 hours.", sender: self)
                        
                    }
                    else
                    {
                        showPopup(msg: "Please try later", sender: self)
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
    
    
    
    
    func showPopupSecond(msg:String, sender:UIViewController)
    {
        let myAlert = UIAlertController(title: "Alert", message: msg, preferredStyle: UIAlertController.Style.alert)
        
        let OKAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {
            (_)in
            
            self.performSegue(withIdentifier: "backHome", sender: nil)
        })
        myAlert.addAction(OKAction)
        sender.present(myAlert, animated: true, completion: nil)
    }
    
    
}
