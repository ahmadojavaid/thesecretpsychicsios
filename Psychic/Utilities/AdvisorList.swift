//
//  AdvisorList.swift
//  Psychic
//
//  Created by APPLE on 1/7/19.
//  Copyright © 2019 Jobesk. All rights reserved.
//

import UIKit
import Nuke
import AVFoundation
import MediaPlayer
import AudioToolbox
import AVKit



protocol videoPlayBtnDelegate
{
    func closeFriendsTapped(at index:String)
}

class AdvisorList: UIViewController {
    
    
    
    @IBOutlet weak var onlineView: UIView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var chatBtn: UIButton!
    @IBOutlet weak var liveBtn: UIButton!
    
    var delegate:videoPlayBtnDelegate!
    @IBOutlet weak var oneStar: UIImageView!
    @IBOutlet weak var twoStar: UIImageView!
    @IBOutlet weak var threeStar: UIImageView!
    @IBOutlet weak var fourStar: UIImageView!
    @IBOutlet weak var fiveStar: UIImageView!
    
    var abc = String()
    var rating = String()
    var userName = String()
    var desc = String()
    var ad_video = String()
    var isOnline = String()
    
    var liveChat = String()
    var threeMinuteVideo = String()
    
    var advisorId = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        userImage.clipsToBounds = true
        userImage.layer.cornerRadius = 10
        let url = URL(string: abc)
        Nuke.loadImage(with: url!, into: userImage)
        tempLabel.text = desc
        nameLabel.text = userName
        
        if isOnline == "0"
        {
            onlineView.backgroundColor = .gray
        }
        else
        {
            onlineView.backgroundColor = .green
        }
        
        if liveChat == "1"
        {
            chatBtn.isHidden = false
        }
        else
        {
            chatBtn.isHidden = true
        }
        
        if threeMinuteVideo == "1"
        {
           liveBtn.isHidden = false
        }
        else
        {
           liveBtn.isHidden = true
        }
        

        print("My rating is \(rating)")
        let myString1 = rating
        let myDouble = Double(myString1)
        
        let myInt = Int(myDouble!)
        
        print("My Interger rating is \(String(describing: myInt))")
        
        
        
        rating = "\(myInt)"
        if rating == "0"
        {
            oneStar.image = UIImage(named: "star")
            twoStar.image = UIImage(named: "star")
            threeStar.image = UIImage(named: "star")
            fourStar.image = UIImage(named: "star")
            fiveStar.image = UIImage(named: "star")
            
        } else if rating == "1"
        {
            oneStar.image = UIImage(named: "filledStar")
            twoStar.image = UIImage(named: "star")
            threeStar.image = UIImage(named: "star")
            fourStar.image = UIImage(named: "star")
            fiveStar.image = UIImage(named: "star")
        } else if rating == "2"
        {
            oneStar.image = UIImage(named: "filledStar")
            twoStar.image = UIImage(named: "filledStar")
            threeStar.image = UIImage(named: "star")
            fourStar.image = UIImage(named: "star")
            fiveStar.image = UIImage(named: "star")
        } else if rating == "3"
        {
            oneStar.image = UIImage(named: "filledStar")
            twoStar.image = UIImage(named: "filledStar")
            threeStar.image = UIImage(named: "filledStar")
            fourStar.image = UIImage(named: "star")
            fiveStar.image = UIImage(named: "star")
        } else if rating == "4"
        {
            oneStar.image = UIImage(named: "filledStar")
            twoStar.image = UIImage(named: "filledStar")
            threeStar.image = UIImage(named: "filledStar")
            fourStar.image = UIImage(named: "filledStar")
            fiveStar.image = UIImage(named: "star")
        } else if rating == "5"
        {
            oneStar.image = UIImage(named: "filledStar")
            twoStar.image = UIImage(named: "filledStar")
            threeStar.image = UIImage(named: "filledStar")
            fourStar.image = UIImage(named: "filledStar")
            fiveStar.image = UIImage(named: "filledStar")
        }
        
        
        
        
    }
    

    @IBAction func nextScreenBtn(_ sender: Any)
    {
        performSegue(withIdentifier: "adDetails", sender: nil)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "adDetails"
        {
                let vc = segue.destination as! ShowAdvisorDetails
                print("Advisor id \(self.advisorId)")
                    vc.advisorID = self.advisorId
            
            
            
            
        }
        
        
    }
    
    
    @IBAction func playVideoBtn(_ sender: Any)
    {
        print("I am here")
        
        //self.delegate?.closeFriendsTapped(at: ad_video)
    }
    
    
    
    
    
    
}
