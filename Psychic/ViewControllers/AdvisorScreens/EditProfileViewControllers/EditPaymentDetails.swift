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

class EditPaymentDetails: UIViewController {
    
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
    var dob = String()
    var dbArray = [String]()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title  = "Payment Details"
        
        minuteRate.text = TIME_RATE
        chatRate.text   = CHAT_RATE
        legalName.text = LGL_NAME
        country.text = COUNTRY
        permanentAddress.text = ADDRESS
        zipCode.text = ZIP_CODE
        cityName.text = CITY
        backAccountNumber.text = BANK_DETAILS
        paymentThrash.text = PAYMENT
        if DATE_OF_BIRTH.contains("-")
        {
            dbArray = DATE_OF_BIRTH.components(separatedBy: "-")
        } else if DATE_OF_BIRTH.contains("/")
        {
            dbArray = DATE_OF_BIRTH.components(separatedBy: "/")
        }
        birthYear.text = dbArray[0]
        birthMonth.text = dbArray[1]
        birthDay.text = dbArray[2]
        
        let value = chatRate.text!
        let aa = Double(value)
        let fourty = aa! * 40 / 100
        self.chatRateLabel.text = "You will earn: £ \(fourty)"
        
        
        let backButton = UIBarButtonItem (image: UIImage(named: "chotaBack")!, style: .plain, target: self, action: #selector(GoToBack))
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.hidesBackButton = true
        
        
        
        
    }
    @objc func GoToBack()
    {
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // 2
        let saveAction = UIAlertAction(title: "Discard Changes?", style: .default)
        { action -> Void in
            
            self.backScreen()
        }
        
        // 3
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        // 4
        
        optionMenu.addAction(saveAction)
        optionMenu.addAction(cancelAction)
        
        // 5
        self.present(optionMenu, animated: true, completion: nil)
    }
    func backScreen()
    {
        print("I am called")
        
        self.performSegue(withIdentifier: "adHome", sender: self)
        
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
                showPopup(msg: "Legal Name must not containt special characters or numbers ", sender: self)
        }
        else if bDay.isEmpty
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
                    if cc > 2050 || cc < 1980
                    {
                        showPopup(msg: "Please provide a valid year", sender: self)
                    }
                    else if molak.isEmpty
                    {
                        showPopup(msg: "Please type a valid country Name", sender: self)
                    } else if checkName(name: molak)
                    {
                        showPopup(msg: "Country name must not contain special character or numbers", sender: self)
                    } else if address.isEmpty
                    {
                        showPopup(msg: "Please type a valid address", sender: self)
                    } else if zip.isEmpty
                    {
                        showPopup(msg: "Please type a valid zip code", sender: self)
                    } else if checkZipCode(name: zip)
                    {
                        showPopup(msg: "Zip Code must not contain special character", sender: self)
                    }else if city.isEmpty
                    {
                        showPopup(msg: "Please type a valid city Name", sender: self)
                    } else if acc.isEmpty
                    {
                        showPopup(msg: "Please type a valid bank account number", sender: self)
                    } else if CHECK_EMAIL(testStr: acc)
                    {
                        if payment.isEmpty
                        {
                            showPopup(msg: "Please type payment thrashold", sender: self)
                        } else
                        {
                            print("All values there call the function....")
                            dob = bYear+"-" + bMonth+"-" + bDay
                            update()
                        }
                    }
                    else
                    {
                            showPopup(msg: "Please Enter a valid PayPal email", sender: self)
                    }
                        
                        
                }
                
            }
        }
        
        
    }
    
    
    @IBAction func sessionRateChanged(_ sender: UITextField) {
        
        
        let value = chatRate.text!
        
        if value == "0"
        {
            self.chatRateLabel.text = "You will earn 40% off your charges"
        }
        else
        {
            if value.count == 0
            {
                self.chatRateLabel.text = "You will earn 40% off your charges"
            }
            else
            {
                let aa = Double(value)
                let fourty = aa! * 40 / 100
                self.chatRateLabel.text = "You will earn: £ \(fourty)"
            }
            
        }
        
        
        
        
        
    }
    
    
    
    
    
    func update()
    {
         assignCategories()
        
       
    }
    
    
    func uploadVideo ()
    {
                    let id = DEFAULTS.string(forKey: "user_id")!
                    Alamofire.upload(multipartFormData: { (multipartFormData) in
                        multipartFormData.append(VIDEO_URL!, withName: "profileVideo")
                        multipartFormData.append(id.data(using: .utf8)!, withName: "advisorId")
                    }, to:BASE_URL+"uploadVid")
                    { (result) in
                        switch result {
                        case .success(let upload, _ , _):
                            upload.uploadProgress(closure: { (progress) in
        
                                print("uploding\(progress)")
        
        
                                let total = progress.totalUnitCount
                                let obt  = progress.completedUnitCount
        
                                let per = Double(obt) / Double(total) * 100
        
        
                                let pp = Int(per)
                                SVProgressHUD.show(withStatus: "uploading Video \n\n \(pp)% Uploading")
                                self.view.isUserInteractionEnabled = false
        
        
        
        
        
                            })
        
                            upload.responseJSON { response in
        
                                SVProgressHUD.dismiss()
                                print("done")
                                self.paymenyInformationUpdate()
                                self.view.isUserInteractionEnabled = true
                            }
        
                        case .failure(let encodingError):
                            print("failed")
                            print(encodingError)
        
                        }
                    }
    }
    
    
    
    
    
    func assignCategories()
    {
        if Reach.isConnectedToNetwork()
        {

            SVProgressHUD.show(withStatus: "Updating your information")
            let baseurl = URL(string:BASE_URL+"assignCat")!
            var parameters = Parameters()
            
            let id = DEFAULTS.string(forKey: "user_id")!
            parameters = ["categories":NEW_CATEGORIES, "advisorId":id]
            Alamofire.request(baseurl, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON{ (responseData) -> Void in
                if((responseData.result.value) != nil)
                {
                    SVProgressHUD.dismiss()
                    let a = JSON(responseData.result.value)
                    
                    let statusCode = "\(a["statusCode"])"
                    
                    if statusCode == "1"
                    {
                       
                        if AAAA == "1"
                        {
                            
                            print("Video is Chanaged and upload")
                            self.uploadVideo()
                        }
                        else
                        {
                            self.paymenyInformationUpdate()
                        }
                        
                        
                    }
                    else
                    {
                        showPopup(msg: "Please try later", sender: self)
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
            showPopup(msg: "Internet could not connect", sender: self)
            
        }
    }
    
    
   func paymenyInformationUpdate()
   {
    
    if Reach.isConnectedToNetwork()
    {
        
        
        CHAT_RATE = chatRate.text!
        TIME_RATE = minuteRate.text!
        LGL_NAME = legalName.text!
        COUNTRY = country.text!
        ADDRESS = permanentAddress.text!
        ZIP_CODE = zipCode.text!
        CITY = cityName.text!
        BANK_DETAILS = backAccountNumber.text!
        PAYMENT = paymentThrash.text!
        
        let id = DEFAULTS.string(forKey: "user_id")!
        let baseurl = URL(string:BASE_URL+"updateAdvisorInfo/"+id)!
        SVProgressHUD.show(withStatus: "Saving your payment details")
        
        var parameters = Parameters()
        
        
        if IMAGE_CHANGED == "1"
        {
            parameters = ["paymentThreshold":PAYMENT, "bankDetails":BANK_DETAILS, "city":CITY, "ZipCode":ZIP_CODE, "permanentAddress":ADDRESS, "country":COUNTRY, "DateofBirth":self.dob, "legalNameOfIndividual":LGL_NAME, "TextChatRate":CHAT_RATE, "YourTimeRate":
                TIME_RATE, "profileStatus":"1", "aboutYourServices":SERVICE_DESC, "instructionForOrder":ORDER_INSTRUCTION, "aboutMe":ABOUT_ME_TEXT, "screenName":SCREEN_NAME, "serviceName":SERVICE_NAME, "profileImage":PROFILE_IMAGE, "expirience":ADVISOR_EXPRIENCE]
        }
        else
        {
            parameters = ["paymentThreshold":PAYMENT, "bankDetails":BANK_DETAILS, "city":CITY, "ZipCode":ZIP_CODE, "permanentAddress":ADDRESS, "country":COUNTRY, "DateofBirth":self.dob, "legalNameOfIndividual":LGL_NAME, "TextChatRate":CHAT_RATE, "YourTimeRate":
                TIME_RATE, "profileStatus":"1", "aboutYourServices":SERVICE_DESC, "instructionForOrder":ORDER_INSTRUCTION, "aboutMe":ABOUT_ME_TEXT, "screenName":SCREEN_NAME, "serviceName":SERVICE_NAME, "expirience":ADVISOR_EXPRIENCE]
        }

        Alamofire.request(baseurl, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON{ (responseData) -> Void in
            if((responseData.result.value) != nil)
            {
                SVProgressHUD.dismiss()
                
                
                let a = JSON(responseData.result.value)
                
                let statusCode = "\(a["statusCode"])"
                
                if statusCode == "1"
                {
                    
                    let defaults = UserDefaults.standard
                    let dictionary = defaults.dictionaryRepresentation()
                    dictionary.keys.forEach { key in
                        defaults.removeObject(forKey: key)
                    }
                    DEFAULTS.set("1", forKey: "walk")
                    self.performSegue(withIdentifier: "homeeeees", sender: nil)  
                }
                else
                {
                    showPopup(msg: "Please try later", sender: self)
                }
                
                
                print("After Updating Data")
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
    @IBAction func chatRateChanged(_ sender: Any)
    {
       
            let value = chatRate.text!
            if value.isEmpty
            {
                self.chatRateLabel.text = "You will earn 40% off your charges"
            }
            else
            {
                print("I am here")
                let aa = Double(value)
                let fourty = aa! * 40 / 100
                self.chatRateLabel.text = "You will earn: £\(fourty)"
                
            }
    }
    
    
}

