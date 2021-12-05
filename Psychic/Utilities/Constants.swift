//
//  Constants.swift
//  Psychic
//
//  Created by APPLE on 12/28/18.
//  Copyright © 2018 Jobesk. All rights reserved.
//

import Foundation
import SwiftyJSON



let BASE_URL = "http://thesecretpsychics.com/"
let IMAGE_BASE_URL = "https://thesecretpsychics.com/api/public"
let ADV_LOG_OUT_API = "https://thesecretpsychics.com/api/public/advisor-logout"

let CLIENT_LOG_OUT_API = "https://thesecretpsychics.com/api/public/client-logout"


let FIRST_PRODUCT = "com.jobesk.thesecretpsychics.myName"
let SECOND_PRODUCT = "com.jobesk.thesecretpsychics.tenPounds"
let THIRD_PRODUCT = "com.jobesk.thesecretpsychics.fivteenPounds"
let FOURTH_PRODUCT = "com.jobesk.thesecretpsychics.fiftyPounds"
let FIVTH_PRODUCT = "com.jobesk.thesecretpsychics.valuePackage"

var oneItem = JSON()


var BOUGHT_PRODUCT = ""
var ONCE_DONE = "0"
var BUY_SCREEN = ""

let DEFAULTS = UserDefaults.standard
func CHECK_EMAIL(testStr:String) -> Bool
{
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: testStr)
}


let myGreenColor = UIColor(red: 100, green: 193, blue: 17)
let myBlueColor = UIColor(red: 0, green: 116, blue: 205)
let myGrayColor = UIColor(red: 112, green: 112, blue: 112)
let myRedColor = UIColor(red: 255, green: 71, blue: 61)
let myBlackColor = UIColor(red: 54, green: 54, blue: 54)





var ADVISOR_NAME = String()
var ADVISOR_IMAGE = String()
var ADVISOR_ID = String()



var ALL_AD = [AdvisorModel]()

var ALL_PAGES = Int()



func showPopup(msg:String, sender:UIViewController)
{
    let myAlert = UIAlertController(title: "Alert", message: msg, preferredStyle: UIAlertController.Style.alert)
    
    let OKAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {
        (_)in
        
        // perform any action here
    })
    myAlert.addAction(OKAction)
    sender.present(myAlert, animated: true, completion: nil)
}

func showPopupWithTwoMsgs(msg1:String, msg2:String,  sender:UIViewController)
{
    let myAlert = UIAlertController(title: msg1, message: msg2, preferredStyle: UIAlertController.Style.alert)
    
    let OKAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {
        (_)in
        
        // perform any action here
    })
    myAlert.addAction(OKAction)
    sender.present(myAlert, animated: true, completion: nil)
}

func showPopupWithOut(msg:String, sender:UIViewController)
{
    
}


func sideMenu(sender:UIViewController, menuBtn:UIButton)
{
    if sender.revealViewController() != nil
    {
        menuBtn.addTarget(sender.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
//        sender.view.addGestureRecognizer(sender.revealViewController().panGestureRecognizer())
        sender.revealViewController().rearViewRevealWidth = 240.0
        
    }
    else
    {   // menu is not assigned
        print("Reveal View is Nil")
    }
}



var FAV_ADVISORS = JSON()

var ALL_ADVISORS = JSON()



var PROFILE_IMAGE = String()
var SCREEN_NAME = String()
var SERVICE_NAME = String()

var ADV_CATEGORIES = JSON()

var NEW_CATEGORIES = String()

var SERVICE_DESC = String()
var ABOUT_ME_TEXT = String()
var ORDER_INSTRUCTION = String()
var ADVISOR_VIDEO = String()
var TIME_RATE = String()
var CHAT_RATE = String()
var LGL_NAME = String()
var DAY = String()
var MONTH = String()
var COUNTRY = String()
var ADDRESS = String()
var ZIP_CODE = String()
var CITY = String()
var BANK_DETAILS = String()
var PAYMENT = String()
var VIDEO_URL: URL?
var ADVISOR_EXPRIENCE = String()
var DATE_OF_BIRTH = String()


var IMAGE_CHANGED = "0"
var VIDEO_CHANGED = "0"

var AAAA = "0"


let LOADING_STRING = "Loading"


func timeInterval(timeAgo:String) -> String
{
    let df = DateFormatter()
    let dateFormat = "yyyy-MM-dd HH:mm:ss"
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





extension String {
    func fromUTCToLocalDateTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        var formattedString = self.replacingOccurrences(of: "Z", with: "")
        if let lowerBound = formattedString.range(of: ".")?.lowerBound {
            formattedString = "\(formattedString[..<lowerBound])"
        }
        guard let date = dateFormatter.date(from: formattedString) else {
            return self
        }
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: date)
    }
}


func checkName(name:String) -> Bool
{
    let characterset = NSCharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ ")
    if name.rangeOfCharacter(from: characterset.inverted) != nil
    {
        return true
    }
    else
    {
        return false
    }
}

func checkAlphaNumeric(name:String) -> Bool
{
    let characterset = NSCharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ123456789 ")
    if name.rangeOfCharacter(from: characterset.inverted) != nil
    {
        return true
    }
    else
    {
        return false
    }
}

func checkZipCode(name:String) -> Bool
{
    let characterset = NSCharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890 ")
    if name.rangeOfCharacter(from: characterset.inverted) != nil
    {
        return true
    }
    else
    {
        return false
    }
}

func checkOnlyNumbers(string: String) -> Bool
{
    let characterset = NSCharacterSet(charactersIn: "1234567890")
    if string.rangeOfCharacter(from: characterset.inverted) != nil
    {
        return true
    }
    else
    {
        return false
    }
}
class Fira18: UILabel {
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)!
        self.font = UIFont(name: "FireSans-Bold", size: 18)
    }
    
}


