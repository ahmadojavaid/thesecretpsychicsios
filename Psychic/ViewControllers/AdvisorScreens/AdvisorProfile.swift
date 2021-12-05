//
//  AdvisorProfile.swift
//  Psychic
//
//  Created by APPLE on 1/4/19.
//  Copyright © 2019 Jobesk. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import SwiftyJSON
import Nuke

class AdvisorProfile: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var menuBTn: UIButton!
    @IBOutlet weak var viewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var menuBackgroundVIew: UIView!
    @IBOutlet weak var menuDots: UIImageView!
    var menuOpen = 0
    
    var happy = 0
    var sad = 0
    var totol = 0
    var count = 0
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var aboutMeData: UILabel!
    @IBOutlet weak var starOne: UIImageView!
    @IBOutlet weak var starTwo: UIImageView!
    @IBOutlet weak var starThree: UIImageView!
    @IBOutlet weak var starFour: UIImageView!
    @IBOutlet weak var starFive: UIImageView!
    
    
    @IBOutlet weak var menuUserName: UILabel!
    @IBOutlet weak var servicesDetails: UILabel!
    @IBOutlet weak var menuAboutMe: UILabel!
    @IBOutlet weak var aboutMyServicesLabel: UILabel!
    @IBOutlet weak var happyLabel1: UILabel!
    @IBOutlet weak var happyLabel2: UILabel!
    @IBOutlet weak var sadFace1: UILabel!
    @IBOutlet weak var sadFace2: UILabel!
    
    @IBOutlet weak var profileBtn: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    var reviews = JSON()
    
    @IBOutlet weak var mmmm: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenu(sender: self, menuBtn: menuBTn)
        
        viewTopConstraint.constant = self.view.frame.height - 220
        

        
        getUerProfile()
        let aa = DEFAULTS.string(forKey: "user_image")!
        let url = URL(string:"\(IMAGE_BASE_URL)"+"\(aa)")
        Nuke.loadImage(with: url!, into:  userProfileImage)
        userProfileImage.contentMode = .redraw
        
        userName.text = DEFAULTS.string(forKey: "userName")!
        menuUserName.text = DEFAULTS.string(forKey: "userName")!
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 80.0
        tableView.rowHeight = UITableView.automaticDimension
   
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
   
    
    @IBAction func btnPrssed(_ sender: Any)
    {
        print("I am clickded")
        if menuOpen == 0
        {
            viewTopConstraint.constant = 8.0
            
            titleView.isHidden = true
            let angle = Double.pi / 2 // here is my computed angle
            let rotate = CABasicAnimation(keyPath: "transform.rotation.z")
            rotate.toValue = angle
            rotate.duration = 0.3
            rotate.isRemovedOnCompletion = false
            rotate.fillMode = CAMediaTimingFillMode.forwards
            menuDots.layer.add(rotate, forKey: "rotate\(angle)")
            
            
            menuBackgroundVIew.backgroundColor = .blue
            
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
                
            }
            
            menuOpen = 1
            
        }
        else
        {
            titleView.isHidden = false
            viewTopConstraint.constant = self.view.frame.height - 150
            menuBackgroundVIew.backgroundColor = .darkGray
            let angle = Double.pi  // here is my computed angle
            let rotate = CABasicAnimation(keyPath: "transform.rotation.z")
            rotate.toValue = angle
            rotate.duration = 0.3
            rotate.isRemovedOnCompletion = false
            rotate.fillMode = CAMediaTimingFillMode.forwards
            
            menuDots.layer.add(rotate, forKey: "rotate\(angle)")
            
            
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
            
            
            menuOpen = 0
        }
        
        
    }
    

    
    
    
    
    func getUerProfile()
    {
        if Reach.isConnectedToNetwork()
        {
            
            let id = DEFAULTS.string(forKey: "user_id")!
            SVProgressHUD.show(withStatus: "Getting your information")
            let baseurl = URL(string:BASE_URL+"showAdvisorInfo/"+id)!
            
            
            var parameters = Parameters()
            parameters = [:]
            Alamofire.request(baseurl, method: .get, parameters: parameters, encoding: URLEncoding.default).responseJSON{ (responseData) -> Void in
                if((responseData.result.value) != nil)
                {
                    SVProgressHUD.dismiss()
                    
                    
                    let a = JSON(responseData.result.value)
                    
                    self.aboutMeData.text = "\(a["Result"][0]["aboutMe"])"
                    let cats = a["Result"][0]["advisorscategories"]
                    var services = ""
                    for i in 0..<cats.count
                    {
                        let a = "\(cats[i]["categoryName"])"
                       services += a
                    }
                    
                    
                    self.servicesDetails.text = services
                    self.menuAboutMe.text = "\(a["Result"][0]["aboutMe"])"
                    self.aboutMyServicesLabel.text = "\(a["Result"][0]["aboutYourServices"])"
                    
                    self.reviews = a["Result"][0]["advisors_reviews"]
                    
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
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reviewCell") as! ReviewTableCell
        
        
        let text = "\(self.reviews[indexPath.row]["updated_at"])"
        
        
        let range: Range<String.Index> = text.range(of: " ")!
        let index: Int = text.distance(from: text.startIndex, to: range.lowerBound)
        let dateonly = text.prefix(index)
        cell.dateLabel.text = "\(dateonly)"
        
        cell.reviewDetails.text = "\(self.reviews[indexPath.row]["feedback"])"
        
        let stars = "\(self.reviews[indexPath.row]["rating"])"
        
        if stars == "1"
        {
            cell.oneStar.image = UIImage(named: "filledStar")
            cell.twoStar.image = UIImage(named: "star")
            cell.threeStar.image = UIImage(named: "star")
            cell.fourStar.image = UIImage(named: "star")
            cell.fiveStar.image = UIImage(named: "star")
        } else if stars == "2"
        {
            cell.oneStar.image = UIImage(named: "filledStar")
            cell.twoStar.image = UIImage(named: "filledStar")
            cell.threeStar.image = UIImage(named: "star")
            cell.fourStar.image = UIImage(named: "star")
            cell.fiveStar.image = UIImage(named: "star")
        } else if stars == "3"
        {
            cell.oneStar.image = UIImage(named: "filledStar")
            cell.twoStar.image = UIImage(named: "filledStar")
            cell.threeStar.image = UIImage(named: "filledStar")
            cell.fourStar.image = UIImage(named: "star")
            cell.fiveStar.image = UIImage(named: "star")
        } else if stars == "4"
        {
            cell.oneStar.image = UIImage(named: "filledStar")
            cell.twoStar.image = UIImage(named: "filledStar")
            cell.threeStar.image = UIImage(named: "filledStar")
            cell.fourStar.image = UIImage(named: "filledStar")
            cell.fiveStar.image = UIImage(named: "star")
        } else if stars == "5"
        {
            cell.oneStar.image = UIImage(named: "filledStar")
            cell.twoStar.image = UIImage(named: "filledStar")
            cell.threeStar.image = UIImage(named: "filledStar")
            cell.fourStar.image = UIImage(named: "filledStar")
            cell.fiveStar.image = UIImage(named: "filledStar")
        }
        
        
        let a = Int(stars)!
        
        if a <= 3
        {
            sad = sad + 1
        }
        else
        {
            happy = happy + 1
        }
        

        self.happyLabel1.text = "\(happy)"
        self.happyLabel2.text = "\(happy)"
        self.sadFace1.text = "\(sad)"
        self.sadFace2.text = "\(sad)"
        
        
        totol = totol + a
        count = count + 1
        
        
        
        
        let avg = totol/count
        
        if avg == 1
        {
            self.starOne.image = UIImage(named: "filledStar")
            self.starTwo.image = UIImage(named: "star")
            self.starThree.image = UIImage(named: "star")
            self.starFour.image = UIImage(named: "star")
            self.starFive.image = UIImage(named: "star")
        } else if avg == 2
        {
            self.starOne.image = UIImage(named: "filledStar")
            self.starTwo.image = UIImage(named: "filledStar")
            self.starThree.image = UIImage(named: "filledStar")
            self.starFour.image = UIImage(named: "star")
            self.starFive.image = UIImage(named: "star")
        } else if avg == 3
        {
            self.starOne.image = UIImage(named: "filledStar")
            self.starTwo.image = UIImage(named: "filledStar")
            self.starThree.image = UIImage(named: "filledStar")
            self.starFour.image = UIImage(named: "star")
            self.starFive.image = UIImage(named: "star")
        } else if avg == 4
        {
            self.starOne.image = UIImage(named: "filledStar")
            self.starTwo.image = UIImage(named: "filledStar")
            self.starThree.image = UIImage(named: "filledStar")
            self.starFour.image = UIImage(named: "filledStar")
            self.starFive.image = UIImage(named: "star")
        } else if avg == 5
        {
            self.starOne.image = UIImage(named: "filledStar")
            self.starTwo.image = UIImage(named: "filledStar")
            self.starThree.image = UIImage(named: "filledStar")
            self.starFour.image = UIImage(named: "filledStar")
            self.starFive.image = UIImage(named: "filledStar")
        }
        
        
   
        
        return cell
    }

}
