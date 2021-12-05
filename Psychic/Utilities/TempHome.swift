//
//  TempHome.swift
//  Psychic
//
//  Created by APPLE on 1/8/19.
//  Copyright © 2019 Jobesk. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
import ProgressHUD

class TempHome: UIViewController {

    
    var fetatures = JSON()
    var all = JSON()
    
    @IBOutlet weak var act: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

     
        let s = CGSize(width: 200, height: 200)
        act.frame.size = s
        act.startAnimating()
        
        
        SVProgressHUD.show(withStatus: "Please wait.....")
        fetchAdvisors()
        
        // Do any additional setup after loading the view.
    }
    

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func fetchAdvisors()
    {
        
        if Reach.isConnectedToNetwork()
        {
            ALL_AD.removeAll()
            let id = DEFAULTS.string(forKey: "user_id")!
            
            let baseurl = URL(string:BASE_URL+"showPsychics?page=1")!
            var parameters = Parameters()
            print("Client URL \(baseurl)")
            parameters = [:]

            Alamofire.request(baseurl, method: .get, parameters: parameters, encoding: URLEncoding.default).responseJSON{ (responseData) -> Void in
                if((responseData.result.value) != nil)
                {
                    SVProgressHUD.dismiss()
                    let a = JSON(responseData.result.value)
                    DB_Handler.deleteAllRecords()
                    let aa = a["featured"]
                    print(aa.count)
                    for i in 0..<aa.count
                    {
                        let ad_des = "\(a["featured"][i]["serviceName"])"
                        let adID = "\(a["featured"][i]["advisorId"])"
                        let adImage = "\(a["featured"][i]["profileImage"])"
                        let adName = "\(a["featured"][i]["screenName"])"
                        let stars = "\(a["featured"][i]["rating"])"//rating
                        let video = "\(a["featured"][i]["profileVideo"])"//rating
                        let isOnline = "\(a["featured"][i]["isOnline"])"
                        let threeMinuteVideo = "\(a["featured"][i]["threeMinuteVideo"])"
                        let liveChat = "\(a["featured"][i]["liveChat"])"
                        if DB_Handler.saveFeatured(ad_desc: ad_des, ad_id: adID, ad_image: adImage, ad_name: adName, ad_stars: stars, ad_video: video, isOnline:isOnline, liveChat: liveChat, threeMinuteVideo: threeMinuteVideo)
                        {
                            print("Data is saved")
                        }
                    }
                    let page1Advisors  = a["All psychics"]["data"]
                    for i in 0..<page1Advisors.count
                    {
                        let id = "\(page1Advisors[i]["id"])"
                        let legalNameOfIndividual = "\(page1Advisors[i]["screenName"])"
                        let serviceName = "\(page1Advisors[i]["serviceName"])"
                        let profileImage = "\(page1Advisors[i]["profileImage"])"
                        let isOnline = "\(page1Advisors[i]["isOnline"])"
                        let rating = "\(page1Advisors[i]["rating"])"
                        let liveChat = "\(page1Advisors[i]["liveChat"])"
                        let threeMinuteVideo = "\(page1Advisors[i]["threeMinuteVideo"])"
                        let oneAdivsor = AdvisorModel(id: id, legalNameOfIndividual: legalNameOfIndividual, serviceName: serviceName, profileImage: profileImage, isOnline: isOnline, rating: rating, liveChat: liveChat, threeMinuteVideo: threeMinuteVideo)
                        ALL_AD.append(oneAdivsor)
                    }
                    ALL_PAGES = Int("\(a["All psychics"]["last_page"])")!
                    print("All psychics")
                    ProgressHUD.dismiss()
                    print(a)
                    self.performSegue(withIdentifier: "hhh", sender: self)
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
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "hhh"
//        {
//            let vc = segue.destination as! ClientHomeScreen
//            vc.allFeatured = self.all
//
//        }
    }


}
