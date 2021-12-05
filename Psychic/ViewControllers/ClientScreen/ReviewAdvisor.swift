//
//  ReviewAdvisor.swift
//  Psychic
//
//  Created by APPLE on 1/14/19.
//  Copyright © 2019 Jobesk. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class ReviewAdvisor: UIViewController {

    @IBOutlet weak var starOne: UIButton!
    @IBOutlet weak var twoOne: UIButton!
    @IBOutlet weak var threeOne: UIButton!
    @IBOutlet weak var fourOne: UIButton!
    @IBOutlet weak var fiveOne: UIButton!
    @IBOutlet weak var feedBAck: UITextView!
    
    
    var advisorId = String()
    var orderId = String()
    
    var rating = "abc"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    @IBAction func ratingStarsPresed(_ sender: Any)
    {
        let tag = (sender as AnyObject).tag
        
        if tag == 1
        {
            rating = "1"
            starOne.setBackgroundImage(UIImage(named: "filledStar"), for: .normal)
            twoOne.setBackgroundImage(UIImage(named: "star"), for: .normal)
            threeOne.setBackgroundImage(UIImage(named: "star"), for: .normal)
            fourOne.setBackgroundImage(UIImage(named: "star"), for: .normal)
            fiveOne.setBackgroundImage(UIImage(named: "star"), for: .normal)
        } else if tag == 2
        {
            rating = "2"
            starOne.setBackgroundImage(UIImage(named: "filledStar"), for: .normal)
            twoOne.setBackgroundImage(UIImage(named: "filledStar"), for: .normal)
            threeOne.setBackgroundImage(UIImage(named: "star"), for: .normal)
            fourOne.setBackgroundImage(UIImage(named: "star"), for: .normal)
            fiveOne.setBackgroundImage(UIImage(named: "star"), for: .normal)
        } else if tag == 3
        {
            rating = "3"
            starOne.setBackgroundImage(UIImage(named: "filledStar"), for: .normal)
            twoOne.setBackgroundImage(UIImage(named: "filledStar"), for: .normal)
            threeOne.setBackgroundImage(UIImage(named: "filledStar"), for: .normal)
            fourOne.setBackgroundImage(UIImage(named: "star"), for: .normal)
            fiveOne.setBackgroundImage(UIImage(named: "star"), for: .normal)
        } else if tag == 4
        {
            rating = "4"
            starOne.setBackgroundImage(UIImage(named: "filledStar"), for: .normal)
            twoOne.setBackgroundImage(UIImage(named: "filledStar"), for: .normal)
            threeOne.setBackgroundImage(UIImage(named: "filledStar"), for: .normal)
            fourOne.setBackgroundImage(UIImage(named: "filledStar"), for: .normal)
            fiveOne.setBackgroundImage(UIImage(named: "star"), for: .normal)
        } else if tag == 5
        {
            rating = "5"
            starOne.setBackgroundImage(UIImage(named: "filledStar"), for: .normal)
            twoOne.setBackgroundImage(UIImage(named: "filledStar"), for: .normal)
            threeOne.setBackgroundImage(UIImage(named: "filledStar"), for: .normal)
            fourOne.setBackgroundImage(UIImage(named: "filledStar"), for: .normal)
            fiveOne.setBackgroundImage(UIImage(named: "filledStar"), for: .normal)
        }
        
        
        
        
    }
    
    @IBAction func submitReviewBrn(_ sender: Any)
    {
        let feed = feedBAck.text!
        
        if rating == "abc"
        {
            showPopup(msg: "Please Choose rating stars", sender: self)
        } else if feed.isEmpty
        {
            showPopup(msg: "Please enter your feed back", sender: self)
        } else
        {
            postReview(rating: rating, feedback: feed)
        }
        
    }
    
    
    
    func postReview(rating:String, feedback:String)
    {
        if Reach.isConnectedToNetwork()
        {
            
            SVProgressHUD.show(withStatus: "Posting your feed back")
            let baseurl = URL(string:BASE_URL+"addreview")!
            var parameters = Parameters()
            
            let id = DEFAULTS.string(forKey: "user_id")!
            parameters = ["advisorId":advisorId, "feedback":feedback, "rating":rating, "userId":id, "orderId":orderId]
            print("Adding Review")
            print(baseurl)
            print(parameters)
            Alamofire.request(baseurl, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON{ (responseData) -> Void in
                if((responseData.result.value) != nil)
                {
                    SVProgressHUD.dismiss()
                    
                    let a = JSON(responseData.result.value)
                    let statusCode = "\(a["statusCode"])"
                    
                    if statusCode == "1"
                    {
                        showPopup(msg: "Review added", sender: self)
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
            showPopup(msg: "Could not conenct to Internet", sender: self)
        }
    }
    
    
}
