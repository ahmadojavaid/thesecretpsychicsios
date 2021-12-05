
import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
import AVFoundation
import MediaPlayer
import AudioToolbox
import AVKit
import Nuke

    class SearchAdvisor: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, AVPlayerViewControllerDelegate, UITextFieldDelegate {
        
        @IBOutlet weak var keywordText: UITextField!
        @IBOutlet weak var collectionView: UICollectionView!
        
        var advisorID = String()
        var currentPage = 1
        var totalPages = Int()
        var allFeatured = [AdvisorModel]()
        
        var searchKeyWord = String()
        
        @IBOutlet weak var wingaMonh: UIImageView!
        @IBOutlet weak var wingaLabel: UILabel!
        override func viewDidLoad() {
            super.viewDidLoad()
            collectionView.delegate = self
            collectionView.dataSource = self
            serachAdvisros(keyword: "a")
            
            
            if self.revealViewController() != nil
            {
                self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
            }
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            
            self.view.endEditing(true)
            search()
            return true
        }
        
       
        
        
        func search()
        {
            self.searchKeyWord = keywordText.text!
            
            if searchKeyWord.isEmpty
            {
                showPopup(msg: "Please enter name to serach ", sender: self)
            }
            else
            {
                print("Search Keyword is \(searchKeyWord)")
                serachAdvisros(keyword: searchKeyWord)
            }
            
        }
        
        func serachAdvisros(keyword:String)
        {
            if Reach.isConnectedToNetwork()
            {
                
                SVProgressHUD.show(withStatus: "Please wait.....")
                let baseurl = URL(string:BASE_URL+"searchAdvisor")!
                print("Serach BASE URL is  \(baseurl)")
                
                var parameters = Parameters()
                
                
                parameters = ["legalName":keyword, "page":"\(currentPage)"]
                
                Alamofire.request(baseurl, method: .get, parameters: parameters, encoding: URLEncoding.default).responseJSON{ (responseData) -> Void in
                    if((responseData.result.value) != nil)
                    {
                        SVProgressHUD.dismiss()
                        
                        let a = JSON(responseData.result.value)
                        
                        
                        
                        
                        let page1Advisors  = a["All psychics"]["data"]
                        self.totalPages = Int("\(a["All psychics"]["last_page"])")!
                        
                        self.allFeatured.removeAll()
                        
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
                            
                            self.allFeatured.append(oneAdivsor)
                        }
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        print("SearchResultss")
                        if self.allFeatured.count == 0
                        {
                            self.collectionView.isHidden = true
                            
                            
                        }
                        else
                        {
                            print("I am here.....")
                            self.collectionView.reloadData()
                        }
                        
                        
                        print(a)
                        
                        
                        //                    self.performSegue(withIdentifier: "hhh", sender: self)
                        
                        
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
        
        
        
        override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
        }
        
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
        {
            return allFeatured.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "advisorsCell", for: indexPath) as! AdvisorCollectionCell
            
            
            cell.userName.text = "\(allFeatured[indexPath.row].legalNameOfIndividual)"
            
            cell.insight.text = "\(allFeatured[indexPath.row].serviceName)"
            
            let img = "\(allFeatured[indexPath.row].profileImage)"
            let add = "\(IMAGE_BASE_URL)"+"\(img)"
            let url = URL(string: add)
            
            Nuke.loadImage(with: url!, into: cell.userImage)
            cell.userImage.clipsToBounds = true
            cell.userImage.layer.cornerRadius = 10
            
            
            
            if "\(allFeatured[indexPath.row].isOnline)" == "0"
            {
                cell.onlineView.backgroundColor = .gray
            }
            else
            {
                cell.onlineView.backgroundColor = .green
            }
            
            
            if "\(allFeatured[indexPath.row].liveChat)" == "0"
            {
                cell.chatBtn.isHidden = true
            }
            else
            {
                cell.chatBtn.isHidden = false
            }
            
            
            
            if "\(allFeatured[indexPath.row].threeMinuteVideo)" == "0"
            {
                cell.videoBtn.isHidden = true
            }
            else
            {
                cell.videoBtn.isHidden = false
            }
            
            
            
            let stars = "\(allFeatured[indexPath.row].rating)"
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
            cell.contentView.layer.cornerRadius = 5.0
            cell.contentView.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
            cell.contentView.layer.borderWidth = 1
            cell.layer.shadowColor = UIColor.gray.cgColor
            cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
            cell.layer.shadowRadius = 1.0
            cell.layer.shadowOpacity = 0.8
            cell.layer.masksToBounds = false

            return cell
        }
        
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
        {
            self.advisorID = "\(allFeatured[indexPath.row].id)"
            self.performSegue(withIdentifier: "det", sender: nil)
            
        }
        
        
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "det"
            {
                let vc =  segue.destination as! ShowAdvisorDetails
                vc.advisorID = self.advisorID
                
                
            }
        }
        
        @objc func chatBtnPressed(_ sender: UIButton!)
        {
            print(sender.tag)
            self.advisorID = "\(sender.tag)"
//            self.performSegue(withIdentifier: "oneChatttt", sender: nil)
        }
        
        
        
        func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
        {
            if indexPath.row == ALL_AD.count - 3
            {  //numberofitem count
                updateNextSet()
            }
        }
        
        func updateNextSet()
        {
            
            if currentPage < totalPages
                {
                    currentPage = currentPage + 1
                    serachAdvisrosNextPage()
                }
            
        }
        
        
        
        func serachAdvisrosNextPage()
        {
            if Reach.isConnectedToNetwork()
            {
                SVProgressHUD.show(withStatus: "Please wait.....")
                let baseurl = URL(string:BASE_URL+"searchAdvisor?legalName="+self.searchKeyWord+"&page="+"\(currentPage)")!
                var parameters = Parameters()
                
                
                parameters = [:]
                
                Alamofire.request(baseurl, method: .get, parameters: parameters, encoding: URLEncoding.default).responseJSON{ (responseData) -> Void in
                    if((responseData.result.value) != nil)
                    {
                        SVProgressHUD.dismiss()
                        
                        let a = JSON(responseData.result.value)
               
                        let page1Advisors  = a["All psychics"]["data"]
                        for i in 0..<page1Advisors.count
                        {
                            let id = "\(page1Advisors[i]["id"])"
                            let legalNameOfIndividual = "\(page1Advisors[i]["legalNameOfIndividual"])"
                            let serviceName = "\(page1Advisors[i]["serviceName"])"
                            let profileImage = "\(page1Advisors[i]["profileImage"])"
                            let isOnline = "\(page1Advisors[i]["isOnline"])"
                            let rating = "\(page1Advisors[i]["rating"])"
                            let liveChat = "\(page1Advisors[i]["liveChat"])"
                            let threeMinuteVideo = "\(page1Advisors[i]["threeMinuteVideo"])"
                            
                            let oneAdivsor = AdvisorModel(id: id, legalNameOfIndividual: legalNameOfIndividual, serviceName: serviceName, profileImage: profileImage, isOnline: isOnline, rating: rating, liveChat: liveChat, threeMinuteVideo: threeMinuteVideo)
                            
                            self.allFeatured.append(oneAdivsor)
                        }

                        print("SearchResultss")
                        if self.allFeatured.count == 0
                        {
                            self.collectionView.isHidden = true
                            //                            self.wingaMonh.isHidden = false
                            //                            self.wingaLabel.isHidden = false
                            
                        }
                        else
                        {
                            print("I am here.....")
                            self.collectionView.reloadData()
                        }
                        
                        
                        print(a)
                        
                        
                        //                    self.performSegue(withIdentifier: "hhh", sender: self)
                        
                        
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

