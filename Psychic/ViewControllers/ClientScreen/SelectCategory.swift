//
//  SelectCategory.swift
//  Psychic
//
//  Created by APPLE on 2/6/19.
//  Copyright © 2019 Jobesk. All rights reserved.
//

//
//  AdvisorCategories.swift
//  Psychic
//
//  Created by APPLE on 12/31/18.
//  Copyright © 2018 Jobesk. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
import Nuke

class SelectCategory: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, SWRevealViewControllerDelegate {
    
    var categories = [CategoryModel]()
    
    var selectedIDs = [String]()
    var categoryName = String()
    var btn = UIButton()
    var catID = String()
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var menuBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenu(sender: self, menuBtn: menuBtn)
        self.title = "Categories"
        getCategories()
        collectionView.delegate = self
        collectionView.dataSource = self
        self.revealViewController()?.delegate = self
        let frame = self.view.frame
        btn.frame = frame
    }
    
    func revealController(_ revealController: SWRevealViewController!, didMoveTo position: FrontViewPosition) {
        
        switch position {
            
        case FrontViewPosition.leftSideMostRemoved:
            print("LeftSideMostRemoved")
            // Left most position, front view is presented left-offseted by rightViewRevealWidth+rigthViewRevealOverdraw
            
        case FrontViewPosition.leftSideMost:
            print("LeftSideMost")
            // Left position, front view is presented left-offseted by rightViewRevealWidth
            
        case FrontViewPosition.leftSide:
            print("LeftSide")
            
        // Center position, rear view is hidden behind front controller
        case FrontViewPosition.left:
            print("Left")
            //Closed
            //0 rotation
            btn.isHidden = true
            
            
        // Right possition, front view is presented right-offseted by rearViewRevealWidth
        case FrontViewPosition.right:
            print("Right")
            
            
            btn.isHidden = false
            btn.addTarget(self, action: #selector(self.pressButton(_:)), for: .touchUpInside)
            
            
            self.view.addSubview(btn)
            
            
            //Opened
            //rotated
            
            // Right most possition, front view is presented right-offseted by rearViewRevealWidth+rearViewRevealOverdraw
            
        case FrontViewPosition.rightMost:
            print("RightMost")
            // Front controller is removed from view. Animated transitioning from this state will cause the same
            // effect than animating from FrontViewPositionRightMost. Use this instead of FrontViewPositionRightMost when
            // you intent to remove the front controller view from the view hierarchy.
            
        case FrontViewPosition.rightMostRemoved:
            print("RightMostRemoved")
            
        }
        
    }
    
    @objc func pressButton(_ sender: UIButton){
        self.revealViewController().revealToggle(animated: true)
        print("\(sender)")
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "selectCategories", for: indexPath) as! CategoriesCell
        cell.catTitle.text = self.categories[indexPath.row].getTitle()
        let aa = self.categories[indexPath.row].getImageAddress()
        let url = URL(string:"\(IMAGE_BASE_URL)"+"\(aa)")
        Nuke.loadImage(with: url!, into: cell.catImage)
        cell.catImage.contentMode = .scaleAspectFit
        if self.categories[indexPath.row].getStaus() == "0"
        {
            cell.checkImage.isHidden = true
        }
        else
        {
            cell.checkImage.isHidden = false
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        
        catID = self.categories[indexPath.row].getID()
        categoryName = self.categories[indexPath.row].getTitle()
        performSegue(withIdentifier: "allAdvisorsByCategory", sender: nil)
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "allAdvisorsByCategory"
        {
            let vc = segue.destination as! CatAdvisor
                vc.catgoryId = catID
                vc.categoryName = categoryName
            
        }
    }
    
    
    
    
    
    
    
    func getCategories()
    {
        if Reach.isConnectedToNetwork()
        {
            
            SVProgressHUD.show(withStatus: "Fetching categories")
            let baseurl = URL(string:BASE_URL+"category")!
            var parameters = Parameters()
            
            
            parameters = [:]
            Alamofire.request(baseurl, method: .get, parameters: parameters, encoding: URLEncoding.default).responseJSON{ (responseData) -> Void in
                if((responseData.result.value) != nil)
                {
                    print("Categories")
                    SVProgressHUD.dismiss()
                    let a = JSON(responseData.result.value)
                    let a_categories = a["Result"]
                    
                    for i in 0..<a_categories.count
                    {
                        let a = a_categories[i]
                        
                        let name  = "\(a["categoryName"])"
                        let catImage = "\(a["appIcons"])"
                        let id = "\(a["id"])"
                        
                        
                        let oneCat = CategoryModel(catImage: catImage, catTitle: name, ID: id)
                        
                        self.categories.append(oneCat)
                    }
                    self.collectionView.reloadData()
                    
                    
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
    
    
    
    func assignCategories()
    {
        if Reach.isConnectedToNetwork()
        {
            
            
            var idsString = ""
            
            for i in 0..<selectedIDs.count
            {
                let id = selectedIDs[i]
                
                idsString = idsString + id + ","
                
                print(idsString)
            }
            
            let aa = idsString.dropLast()
            
            print("with couma is \(aa)")
            let stringIds = "\(aa)"
            
            
            
            SVProgressHUD.show(withStatus: "Saving your categories")
            let baseurl = URL(string:BASE_URL+"assignCat")!
            var parameters = Parameters()
            
            let id = DEFAULTS.string(forKey: "user_id")!
            parameters = ["categories":stringIds, "advisorId":id]
            Alamofire.request(baseurl, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON{ (responseData) -> Void in
                if((responseData.result.value) != nil)
                {
                    SVProgressHUD.dismiss()
                    let a = JSON(responseData.result.value)
                    
                    let statusCode = "\(a["statusCode"])"
                    
                    if statusCode == "1"
                    {
                        self.performSegue(withIdentifier: "personalInformation", sender: nil)
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
    
    
    
    @IBAction func SaveCategories(_ sender: Any)
    {
        if selectedIDs.count > 0
        {
            assignCategories()
        }
        else
        {
            showPopup(msg: "Please Select categories", sender: self)
        }
    }
    
    
    
    
    
    @IBAction func clientSelectCategoryScreen(segue: UIStoryboardSegue)
    {
        
        
    }
    
    @IBAction func backBtn(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
        self.performSegue(withIdentifier: "backHome", sender: nil)
        
    }
}


