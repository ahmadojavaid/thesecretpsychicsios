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

class AdvisorCategories: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
 
    var categories = [CategoryModel]()
    
    var selectedIDs = [String]()
    
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Categories"
        getCategories()
        collectionView.delegate = self
        collectionView.dataSource = self
        nextBtn.isUserInteractionEnabled = false
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
        
        
        
                let id = self.categories[indexPath.row].getID()
                
                var have = Bool()
                var pos = Int()
        
                var a = 1
                for i in 0..<selectedIDs.count
                {
                    
                    if selectedIDs[i] == id
                    {
                        
                        print("id found is \(id)")
                        pos = i
                        a = 2
                        have = true
                    }
                    else
                    {
                        have = false
                    }
                    
                    
                }
        
                print(a)
                if a == 2
                {
                    selectedIDs.remove(at: pos)
                    self.categories[indexPath.row].setStatus(value: "0")
                    
                }
                else
                {
                    if selectedIDs.count == 3
                    {
                        showPopup(msg: "Max 3 item please", sender: self)
                    }
                    else
                    {
                        selectedIDs.append(id)
                        self.categories[indexPath.row].setStatus(value: "1")
                    }
          
                }
                
                
        
        print("Selected ID are \(selectedIDs)")
        
        nextBtn.isUserInteractionEnabled = true
            self.collectionView.reloadData()
        
        
        
        
    }

    
    
    
    
    
    
    func getCategories()
    {
        if Reach.isConnectedToNetwork()
        {
            
            SVProgressHUD.show(withStatus: LOADING_STRING)
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
    
    
    

}
