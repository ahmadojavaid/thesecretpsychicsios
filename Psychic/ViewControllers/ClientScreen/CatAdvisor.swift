
import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
import AVFoundation
import MediaPlayer
import AudioToolbox
import AVKit
import Nuke

class CatAdvisor: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, AVPlayerViewControllerDelegate {
    
    @IBOutlet weak var keywordText: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var title_label: UILabel!
    var categoryName = String()
    
    var allFeatured = JSON()
    
    var catgoryId = String()
    
    var advisorId = String()
    
    
    @IBOutlet weak var wingaMonh: UIImageView!
    @IBOutlet weak var wingaLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        serachAdvisros()
        title_label.text = categoryName
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }
    
    
    func serachAdvisros()
    {
        if Reach.isConnectedToNetwork()
        {
            SVProgressHUD.show(withStatus: "Please wait.....")
            let baseurl = URL(string:BASE_URL+"showPsychicsByCat")!
            var parameters = Parameters()
            parameters = ["categoryId":catgoryId]
            Alamofire.request(baseurl, method: .get, parameters: parameters, encoding: URLEncoding.default).responseJSON{ (responseData) -> Void in
                if((responseData.result.value) != nil)
                {
                    SVProgressHUD.dismiss()
                    let a = JSON(responseData.result.value)
                    self.allFeatured = a["All psychics"]
                    if self.allFeatured.count == 0
                    {
                        self.collectionView.isHidden = true
                        
                    }
                    else
                    {
                    
                        self.collectionView.reloadData()
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
    
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return allFeatured.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "advisorsCell", for: indexPath) as! AdvisorCollectionCell
        
        
        cell.userName.text = "\(allFeatured[indexPath.row]["screenName"])"
        cell.insight.text = "\(allFeatured[indexPath.row]["serviceName"])"
        
        let img = "\(allFeatured[indexPath.row]["profileImage"])"
        let add = "\(IMAGE_BASE_URL)"+"\(img)"
        let url = URL(string: add)
        Nuke.loadImage(with: url!, into: cell.userImage)
        
        cell.userImage.clipsToBounds = true
        cell.userImage.layer.cornerRadius = 10
        cell.chatBtn.tag = indexPath.row
        cell.videoBtn.tag = indexPath.row
        cell.chatBtn.addTarget(self, action: #selector(chatBtnPressed(_:)), for: .touchUpInside)
        cell.videoBtn.addTarget(self, action: #selector(videoBtn(_:)), for: .touchUpInside)
        
        
        let stars = "\(allFeatured[indexPath.row]["rating"])"
        
        if "\(allFeatured[indexPath.row]["isOnline"])" == "0"
        {
            cell.onlineView.backgroundColor = .gray
        }
        else
        {
            cell.onlineView.backgroundColor = .green
        }
        
        
        
        print("Rating is \(stars)")
        let dbl = Double(stars)
        
        print("and other is \(dbl!)")
        
        
        let a = Int(dbl!)
        if a == 0
        {
            cell.oneStar.image = UIImage(named: "star")
            cell.twoStar.image = UIImage(named: "star")
            cell.threeStar.image = UIImage(named: "star")
            cell.fourStar.image = UIImage(named: "star")
            cell.fiveStar.image = UIImage(named: "star")
            
        } else if a == 1
        {
            cell.oneStar.image = UIImage(named: "filledStar")
            cell.twoStar.image = UIImage(named: "star")
            cell.threeStar.image = UIImage(named: "star")
            cell.fourStar.image = UIImage(named: "star")
            cell.fiveStar.image = UIImage(named: "star")
        } else if a == 2
        {
            cell.oneStar.image = UIImage(named: "filledStar")
            cell.twoStar.image = UIImage(named: "filledStar")
            cell.threeStar.image = UIImage(named: "star")
            cell.fourStar.image = UIImage(named: "star")
            cell.fiveStar.image = UIImage(named: "star")
            
        } else if a == 3
        {
            cell.oneStar.image = UIImage(named: "filledStar")
            cell.twoStar.image = UIImage(named: "filledStar")
            cell.threeStar.image = UIImage(named: "filledStar")
            cell.fourStar.image = UIImage(named: "star")
            cell.fiveStar.image = UIImage(named: "star")
            
        } else if a == 4
        {
            cell.oneStar.image = UIImage(named: "filledStar")
            cell.twoStar.image = UIImage(named: "filledStar")
            cell.threeStar.image = UIImage(named: "filledStar")
            cell.fourStar.image = UIImage(named: "filledStar")
            cell.fiveStar.image = UIImage(named: "star")
            
        } else if a == 5
        {
            cell.oneStar.image = UIImage(named: "filledStar")
            cell.twoStar.image = UIImage(named: "filledStar")
            cell.threeStar.image = UIImage(named: "filledStar")
            cell.fourStar.image = UIImage(named: "filledStar")
            cell.fiveStar.image = UIImage(named: "filledStar")
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        self.advisorId = "\(allFeatured[indexPath.row]["id"])"
        self.performSegue(withIdentifier: "allData", sender: nil)
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "allData"
        {
            let vc =  segue.destination as! ShowAdvisorDetails
            vc.advisorID = self.advisorId
            
            
        }
    }
    
    @objc func chatBtnPressed(_ sender: UIButton!)
    {
        print(sender.tag)
//        self.advisorID = "\(sender.tag)"
        //            self.performSegue(withIdentifier: "oneChatttt", sender: nil)
    }
    
    
    @objc func videoBtn(_ sender: UIButton!)
    {
        
        let videoLink = "\(allFeatured[sender.tag]["profileVideo"])"
        let videoURL = URL(string: "\(BASE_URL)"+"\(videoLink)")
        let player = AVPlayer(url: videoURL!)
        let playervc = AVPlayerViewController()
        playervc.delegate = self
        playervc.player = player
        self.present(playervc, animated: true) {
            playervc.player!.play()
        }
        
        
    }
}


